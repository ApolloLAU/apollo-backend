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

// Parse.Cloud.beforeSave('SensorData', async (request) => {
//   const obj = request.object;
//   const all_data = obj.get('ECG');
//   const new_data = obj.get('raw_ECG');
//   if (new_data.length > 0) {
//     const req_url = process.env.ML_API_URL + '/preprocess_ecg'
//
//     const request_obj = {ECG: new_data}
//
//     const response = await axios.post(req_url, request_obj).catch((err) => {
//       console.log('could not process ecg')
//       console.log(err);
//     })
//     // response contains array with same length as input and new last index.
//
//     // overwrite all data array with the cleaned data.
//     // Array.prototype.splice.apply(all_data, [last_index + 1, response.clean_data.length].concat(response.clean_data))
//     let response_object = {}
//     if (typeof response.data === "string") {
//       console.log('Cleaned ECG. Response is:', response.data)
//       response_object = JSON.parse(response.data.replace(/\bNaN\b/g, -1))
//     } else {
//       response_object = response.data
//     }
//
//
//     if (response_object.statusCode === 200) {
//       all_data.push(...response_object.data.clean_ecg)
//       request.object.set('ECG', all_data);
//       const current_bpm = request.object.get('bpm');
//       current_bpm.push(response_object.data.bpm);
//       request.object.set('bpm', current_bpm);
//       request.object.set('raw_ECG', []);
//     }
//   }
// })

Parse.Cloud.define('predict', async (req) => {
  try {
    const samples_per_req = 141;
    const ecgId = req.params.ecg;
    const ecg = await (new Parse.Query("SensorData").equalTo("objectId", ecgId).include('patient').first())

    if (ecg) {
      const clean_ecg = ecg.get('ECG')
      const bpm = ecg.get('bpm')
      if (clean_ecg && bpm && bpm.length > 0 && clean_ecg.length > (samples_per_req * 5)) {

        const nbr_of_intervals = Math.floor(clean_ecg.length / samples_per_req);
        const index = nbr_of_intervals - 1;
        const ecg_values = clean_ecg.slice(index, index + samples_per_req);
        const bpm_val = bpm.length > 0 ? bpm[bpm.length - 1] : -1;

        const patient = ecg.get('patient')
        const year = patient.get('dob').getYear();
        const abnormalities = patient.get('prevConditions');

        const request_obj = {ECG: ecg_values, yearOfBirth: year, prevHeartCond: abnormalities, BPM: bpm_val}
        const req_url = process.env.ML_API_URL + '/predict_ecg'

        const response = await axios.post(req_url, request_obj).catch((err) => {
          console.log('could not process ecg')
          console.log(err);
        })
        console.log('got response from ml:', response)
        const response_object = response.data
        if (response_object.statusCode === 200) {
          const pred1 = response_object.data.bpm_prediction;
          const pred2 = response_object.data.ecg_prediction;

          ecg.set('predicted_diseases', [pred1, pred2])
          await ecg.save()
          return true
        }
      }
    }
  } catch (e) {
    console.log('error while predicting:', e)
  }
  return false;
})

Parse.Cloud.beforeSave('Test', () => {
  throw new Parse.Error(9001, 'Saving test objects is not available.');
});
