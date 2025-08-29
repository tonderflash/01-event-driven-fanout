exports.handler = async (event) => {
  console.log("Hello World! Evento recibido:", JSON.stringify(event, null, 2));

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello World desde Lambda!",
      timestamp: new Date().toISOString(),
      eventRecords: event.Records ? event.Records.length : 0,
    }),
  };
};
