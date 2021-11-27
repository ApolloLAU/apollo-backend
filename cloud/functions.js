const {all} = require("eslint-plugin-promise/rules/lib/promise-statics");
const axios = require('axios').default;

Parse.Cloud.define('hello', req => {
  req.log.info(req);
  return 'Hi';
});

Parse.Cloud.define('asyncFunction', async req => {
  await new Promise(resolve => setTimeout(resolve, 1000));
  req.log.info(req);
  return 'Hi async';
});

// Parse.Cloud.job('deleteAll', req => {
//   console.log("RECEIVED DELETE JOB!");

//   var Schema = Parse.Object.extend("_SCHEMA");
//   var query = new Parse.Query(Schema);

// })

Parse.Cloud.define('getActiveMissions', req => {
  const pipeline = [{ $match: { base_workers: { $size: 0 } } }];
  return new Parse.Query('Mission')
    .equalTo('status', 'deployable')
    .includeAll()
    .aggregate(pipeline);
})
//
// Parse.Cloud.define('preprocessECG', async (req) => {
//   const values = req.params.ecg;
//
// });

Parse.Cloud.beforeSave('SensorData', async (request) => {
  const obj = request.object;
  const all_data = obj.get('ECG');
  const new_data = obj.get('raw_ECG');
  const req_url = process.env.ML_API_URL + '/preprocess_ecg'

  const request_obj = {ECG: new_data}

  const response = await axios.post(req_url, request_obj).catch((err) => {
    console.log('could not process ecg')
    console.log(err);
  })
  // response contains array with same length as input and new last index.

  // overwrite all data array with the cleaned data.
  // Array.prototype.splice.apply(all_data, [last_index + 1, response.clean_data.length].concat(response.clean_data))
  console.log('Cleaned ECG. Response is:', response)
  const response_object = JSON.parse(response.data.replace(/\bNaN\b/g, -1))
  all_data.push(...response_object.data.clean_ecg)
  request.object.set('ECG', all_data);
  const current_bpm = request.object.get('bpm');
  current_bpm.push(response_object.data.bpm);
  request.object.set('bpm', current_bpm);
  request.object.set('raw_ECG', []);

})

Parse.Cloud.beforeSave('Test', () => {
  throw new Parse.Error(9001, 'Saving test objects is not available.');
});
