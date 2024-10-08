const express = require("express");
const bodyParser = require("body-parser");
const { AptosAccount, AptosClient, HexString } = require("aptos");

// Initialize Aptos client
const client = new AptosClient("https://fullnode.devnet.aptoslabs.com");

// Your private key for signing transactions (HexString needed)
const privateKey = new HexString(
  "c78df74c67abaf012b5f924da0742319361114fed62dff5d205479c64f1783d5"
);

// Create AptosAccount from the private key
const aptosAccount = new AptosAccount(privateKey.toUint8Array());

// The address where your contract is deployed
const contractAddress =
  "0x9063b0cae7dd97c0491259a99ef90b35a93d26248c3a4c295872b158cbfdcac7";

const app = express();
app.use(bodyParser.json());

// API to sign transactions
app.post("/sign-transaction", async (req, res) => {
  try {
    const {
      sender,
      sequence_number,
      max_gas_amount,
      gas_unit_price,
      expiration_timestamp_secs,
      capacity,
      rentalRate,
    } = req.body;

    // Check if all required fields are present
    if (
      !sender ||
      !sequence_number ||
      !max_gas_amount ||
      !gas_unit_price ||
      !expiration_timestamp_secs ||
      !capacity ||
      !rentalRate
    ) {
      throw new Error("Missing required fields in the request");
    }

    // Create the payload for the transaction
    const payload = {
      type: "entry_function_payload",
      function: `${contractAddress}::SolarPanelRental::list_panel`,
      type_arguments: [],
      arguments: [capacity, rentalRate],
    };

    // Create the transaction request
    const txnRequest = await client.generateTransaction(sender, payload, {
      sequence_number,
      max_gas_amount,
      gas_unit_price,
      expiration_timestamp_secs,
    });

    // Sign the transaction using the AptosAccount
    const signedTxn = await client.signTransaction(aptosAccount, txnRequest);

    // Send the signed transaction back to the client
    res.json({ signedTxn });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});




// Start the server
app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
