exports.helloWorld = function helloWorld (event, callback) {
  console.log(`My Cloud Function: ${JSON.stringify(event.data.message)}`);
  callback();
};
