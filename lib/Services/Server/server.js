const stripe = require('stripe')('sk_test_51Q72aWGr9UhAIQLOGyfKF55sinVoJ8FbiLP8uIRj5Oirg04lSEeUs6VNfG75wQwikHqu2kMhHK5zZYQVuU8JcjOX00LaL8dFr0');
const express = require('express');
const cors = require('cors');  // CORS middleware for cross-origin requests
const app = express();

app.use(express.json());  // Parse incoming request bodies
app.use(cors());  // Enable CORS for all requests

app.post('/create-payment-intent', async (req, res) => {
  try {
    const { amount } = req.body;

    if (!amount) {
      return res.status(400).send({ error: 'Amount is required' });
    }

    // Create a PaymentIntent with the dynamic amount and currency
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount, // Using dynamic amount from request
      currency: 'usd', // Add the currency field, you can change to pkr if needed
      automatic_payment_methods: {
        enabled: true, // Automatically detect the payment method
      },
    });

    // Send the client secret to the frontend
    res.send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    // Handle errors and send a meaningful message back to the client
    res.status(500).send({ error: error.message });
  }
});

app.listen(4242, () => console.log('Node server running on port 4242!'));
