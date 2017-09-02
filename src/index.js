exports.handler = (event, context, callback) => {
    const response = {
        application: {
            name: 'Terraform - Proof of concept',
            version: '1.0.0',
            build: '1',
            time: Date.now()
        }
    };
    callback(null, response);
};

