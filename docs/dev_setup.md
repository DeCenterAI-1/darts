# Setup Darts Network for development on your machine

## Setup repo

```shell
git repo clone darts2024/darts
cd darts
```

```bash
make
cp .env.example .env
./darts version
```

## Setup env vars for services

### Generate addresses for services

```shell
cd hardhat
pnpm gen-env
```

1. Open `hardhat/.env.gen`
2. Pick the private keys and paste it appropriately to .env file

### For `DARTS_SOLVER`

```shell
source .env
cd hardhat
pnpm account $SOLVER_PRIVATE_KEY
```

1. Copy the account address
2. Paste it to DARTS_SOLVER in the `.env` file

### Setup Metamask

1. **Install MetaMask**: If you haven't already, install the MetaMask extension for your web browser or the MetaMask
   mobile app from the respective app store.

2. **Open MetaMask**: Launch the MetaMask extension or app on your device.

3. **Access Settings**: Look for the settings menu in MetaMask. This is usually represented by a gear or three dots
   icon.

4. **Select "Import Account"**: In the settings menu, find the option to import an account. Click on it to proceed.

5. **Enter Private Key**: You'll be prompted to enter the private key associated with the account you want to import.
   Make sure you have the correct private key.

6. **Complete Import**: Follow the prompts to complete the import process. You may need to confirm your action with a
   password or additional verification.

7. **Verify and Access Imported Account**: Once the import process is complete, you should see the imported account in
   your MetaMask wallet along with any existing accounts you have.

8. **Ensure Security**: After importing your account, it's important to ensure the security of your MetaMask wallet.
   Make sure to keep your private key secure and never share it with anyone.

> Do the same for all the private keys

## Setup Darts Services

### Setup Solver

`darts solver`

Solver runs on $SERVER_PORT. Solver stores $SERVER_URL in the blockchain for `RP` & `JC` to communicate with it
over `http`

### Setup Resource Provider

`darts rp`

RP posts resource offers to `DARTS SOLVER` over the solver url published by solver.

### Run a darts module on the rp

`darts run cowsay:v0.1.3 -i Message="Ideomind is full of ideas"`

`run` command leverages `jobcreator` under the hood. **JC** posts the **job offer** to solver over solver url.
`solver` matches the job offer with the suitable resource offers and creates many deals. The deals are queried by **RP**
and
**JC** where they can accept or reject the deals. Upon acceptance of a deal on both ends, the **RP** runs the job and
submits the results to **solver**. **Solver** then verifies the job results. **JC** queries the verifies the results and
downloads the results from the **Solver**.
