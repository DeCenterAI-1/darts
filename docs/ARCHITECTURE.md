## table of contents

- [architecture](#architecture)
  - [layers](#layers)
  - [smart contracts](#smart-contracts)
  - [services](#services)
  - [job workflow](#job-workflow)
- [local development](#local-development)
  - [pre-requisites](#pre-requisites)
  - [initial setup](#initial-setup)
  - [run web3 stack](#run-web3-stack)
  - [run services](#run-services)
  - [run faucet](#run-faucet)
  - [run jobs](#run-jobs)
  - [stop stack](#stop-stack)
  - [unit tests](#unit-tests)
  - [regenerating go bindings](#regenerating-go-bindings)
- [production deployment](#production-deployment)
  - [generate production keys](#generate-production-keys)
  - [funding accounts](#funding-accounts)
  - [deploy contracts](#deploy-contracts)
    - [add hardhat network](#add-hardhat-network)
    - [deploy contracts](#deploy-contracts-1)
    - [note addresses](#note-addresses)
  - [generate service .env files](#generate-service-env-files)
  - [systemd files](#systemd-files)
- [troubleshooting](#troubleshooting)
  - [receive buffer size error](#receive-buffer-size-error)

## architecture

### layers

The following diagram shows the high level architecture of the system:

![Layers](images/layers.png)

### smart contracts

The following diagram shows the various smart contracts that are part of the system:

![Smart Contracts](images/smart-contracts.png)

### services

The following diagram shows the various services that are part of the system:

![Services](images/services.png)

### job workflow

The following diagram shows the workflow of a job:

#### 1.Deal Agreement

First, the deal is matched by the solver and agreed to by both sides:

![1.Deal Agreement](images/1.deal-agreement.png)

#### 2.Post Results

Then, the resource provider posts the results of the job:

![2.Post Results](images/2.post-results.png)

#### 3.Accept Results

In the case that the job creator is happy, they will acept the results:

![3.Accept Results](images/3.accept-results.png)

#### 4.Check Results (correct)

In the case that the job creator is not happy but the resource provider was honest:

![4.Check Results (correct)](images/4.check-results-correct.png)

#### 5.Check Results (incorrect)

In the case that the job creator is not happy but the resource provider was not honest:

![5.Check Results (incorrect)](images/5.check-results-incorrect.png)

## local development

This section will demonstrate how to run the stack on your local machine.

### pre-requisites

You will need the following tools:

- go (>= v1.20)
  - see [golang-backports](https://launchpad.net/%7Elongsleep/+archive/ubuntu/golang-backports) for ubuntu
  - after enabling the PPA, run: `sudo apt install -y golang-go`
- docker
  - `docker.io` ubuntu package is sufficient for controlplane
  - use [docker on ubuntu](https://docs.docker.com/engine/install/ubuntu/)
    and [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
    for GPU-enabled resource-providers (these will be preinstalled in certain environments, e.g. Lambda Labs)
- node.js (v18)
  - see [nodesource distributions](https://github.com/nodesource/distributions?tab=readme-ov-file#using-ubuntu-2)
  - also install yarn globally: `sudo npm install -g pnpm`

### initial setup

These steps only need to be done once.

#### install bacalhau

```bash
./install.sh bacalhau
```

```stdout
 CLIENT  SERVER  LATEST  UPDATE MESSAGE
 v1.2.3  v1.2.3  v1.2.3
```

#### Faucet

```bash
cd darts-faucet
```

#### install stack

```bash
cd darts
./setup install
```

This script will:

- build the faucet docker image from the locally cloned repo
- download the go modules
- install the node modules for hardhat
- install the node modules for the frontend
- compile the solidity contracts and generate the typechain bindings
- generate the dev `.env` file with insecure private keys

After you've run the install script - you can look inside of `.env` to see the core service private keys and addresses
that are used in the local dev stack.

### run web3 stack

These steps boot geth, deploy our contracts and ensure that the various services named in `.env` are funded with ether
and tokens.

```bash
cd darts
chmod +x ./setup
./setup boot
```

This script will:

- start geth as a docker container
- fund the admin account with ether
- fund the various services with ether
- compile and deploy the solidity contracts
- fund the various services with tokens
- print the balances of the various accounts in `.env`

### run services

#### solver

Run the following commands in separate terminal windows:

```bash
./setup solver
```

#### mediator

Wait for the solver to start when `🟡 SOL solver registered` is logged, and then, in another terminal window, run:

```bash
./setup mediator
```

#### Jobcreator

In another terminal window run:

```bash
./setup jc
```

#### bacalhau

In another terminal window run:

```bash
# Set the IPFS data path by exporting the `BACALHAU_SERVE_IPFS_PATH` variable to your desired location
#export BACALHAU_SERVE_IPFS_PATH=/var/lib/darts/data/ipfs
#sudo mkdir -p ${BACALHAU_SERVE_IPFS_PATH}
./setup bacalhau-serve
```

#### resource-provider

If you have a GPU, run the following command in a separate terminal window:

```bash
./setup rp --offer-gpu 1
```

Otherwise, if you don't have a GPU:

```bash
./setup rp
```

### run faucet

To run the faucet container so you can test with other user accounts:

```bash
./setup faucet
```

Once the faucet is running, you can access it using http://localhost:8085

**NOTE**: if you want a different logo or otherwise a different design for the faucet, fork
the [repo](https://github.com/bacalhau-project/eth-faucet) and use that as your basis for the faucet container.

You can find the frontend code in the `web` directory and the images are in the `web/public` directory.

### run jobs

Now you can run jobs on the stack as follows:

```bash
./setup run cowsay:v0.1.2 -i Message="Jerry shoots a dart at Tom"
```

If you have a GPU node - you can run SDXL (which needs a GPU):

```bash
./setup runsdxl sdxl:v0.3.0 "Sharp darts"
```

To demonstrate triggering jobs being run from on-chain smart contracts:

```bash
./setup run-cowsay-onchain
```

### stop stack

To stop the various services you have started in the numerous terminal windows, `ctrl+c` will suffice.

To stop geth:

```bash
./setup geth-stop
```

<!--
To stop the faucet:

```bash
./setup faucet-stop
```
There is no faucet-stop in stack

-->

To reset Geth data, effectively performing a complete restart, use the following command:

```bash
./setup clean
```

Please note that after running `clean`, you will need to re-run the `fund-admin` and `fund-services` commands.

### unit tests

Run the smart contract unit tests with the following command:

```bash
./setup unit-tests
```

### regenerating go bindings

Whenever you make changes to the smart contracts, regenerate the Go bindings in `pkg/contract/bindings/contracts` by
running:

```bash
./setup compile-contracts
```

## production deployment

Running the darts in a production environment will require:

- an EVM compatible blockchain for which you have a private key with funds
  - you will use this `admin` private key to fund our various services
- a VM (or multiple) connected to the Internet
  - the solver will require a public http(s) endpoint
  - it is recommended that you use a reverse proxy to terminate TLS and forward to the solver
- a compiled binary of bacalhau
  - see the development instructions for how to get this onto the machine
  - it must live on the VM at the `/usr/bin/bacalhau` path
- a compiled binary of the darts
  - this can be compiled locally or in CI
  - it must live on the VM at the `/usr/local/bin/darts` path
- docker running on the vm that will serve the faucet
  - the faucet will require a public http(s) endpoint~
    - it is recommended that you use a reverse proxy to terminate TLS and forward to these services

We will use hardhat to deploy our contracts and then a combination of systemd and docker-compose to manage our services.

### generate production keys

Regardless of what blockchain we use, we will need the private keys and associated addresses for each of our services.

To generate these for a new deployment - you can run the following command:

```bash
./setup print-env
```

This will print the private keys and addresses to stdout so to create a production `.env` file, you can do the
following:

```bash
./setup print-env > .env
```

If you plan to run geth locally, also add to `.env.geth`:

```
export LOG_LEVEL=info
export NETWORK=geth
export WEB3_RPC_URL=ws://localhost:8546
export WEB3_CHAIN_ID=1337
```

### funding accounts

Each of our services will need some base currency to pay gas and for a production deployment, you will need to fund
these accounts manually. This is by design as compared to the local dev stack (where we use a script) because there are
various block-chains and account arrangements that could be used for different networks.

This is just to pay gas - we will deploy the darts ERC-20 token to pay for jobs.

**NOTE** it should be fairly trivial to change the payments contract to re-use an existing ERC-20 token.

You can see the account addresses by looking in the `prod.env` you just made.

The following is a list of each account that needs to be funded:

- `ADMIN`
- `FAUCET`
- `SOLVER`
- `MEDIATOR`
- `RESOURCE_PROVIDER`

All of these accounts will need enough ether to pay for gas, how much this is depends on the network you are using (i.e.
how much gas costs) and how busy that network is.

We recommend looking at the balances of the local dev stack to understand how much ether will be required to pay gas.

In a production network - the `JOBCREATOR` will be end users who should get their own either to pay gas (this also
applies to tokens to pay for jobs).

If you want to run your own geth testnet, you can start geth and transfer funds from the admin account of your local
geth to the SECURE (non-development) addresses you created by running (after the `./setup generate-addresses > prod.env`
step above):

```bash
./setup geth
export CONFIG_FILE=prod.env
./setup fund-admin
./setup deploy
./setup fund-services-ether
```

### deploy contracts

(skip this step if you are using your own geth, the step above will already have done it)

Now it's time to deploy our contracts to the blockchain we are using, to do this, we need to add a `network` to the
hardhat config.

#### add hardhat network

Open `hardhat/hardhat.config.ts` and add a new network to the `networks` array:

Obviously change these values to match your network:

```typescript
{
    name: "production",
        url
:
    "https://mainnet.infura.io/v3/PROJECT_ID",
        accounts
:
    [process.env.ADMIN_PRIVATE_KEY],
        chainId
:
    1,
        gasPrice
:
    100000000000,
        gas
:
    10000000,
        timeout
:
    600000,
}
```

#### deploy contracts

Then we can deploy our contracts using the following command:

```bash
DOTENV_CONFIG_PATH='../prod.env' npx hardhat deploy --network production
```

It's important to set the `DOTENV_CONFIG_PATH` value so we use the actual admin account we just funded.

It's also important to match the `--network production` to the name of the network you actually added
to `hardhat.config.ts`.

#### note addresses

Once the contracts have been deployed - make a note of the addresses they have been deployed to (hardhat will print
these to stdout or you can look in `hardhat/deployments/*/<ContractName>.json`).

We will be required to add some of these contract addresses to `.env` files later.

### generate service .env files

Now we need to create the `.env` files for each of our services. Once created, we will upload these files to the vm(s)
you are going to run the services on and then configure the systemd units to use them.

The systemd units in the `systemd` folder all mention `/app/darts` as the location of their `.env` files, you are
free to change the name of this folder (as long as you then upload the `.env` files you create to that folder).

We also need to have a data folder for `ipfs` - like above, the systemd units are configured to point
at `/app/darts/ipfs` - you can change this folder but make sure to update the systemd units to what you created on
the vm.

The format of these files is classic env format as follows (using the solver as an example):

```
WEB3_PRIVATE_KEY=XXX
SERVER_PORT=80
SERVER_URL=https://my-cool-network.io
```

**NOTE** in the example above - we will have setup a TLS terminating reverse proxy such
that `https://my-cool-network.io` will forward to the solver VM on port 80.

The following is a guide to env vars for setting up **Darts Services **:

Its preferred to store the vars in a a single `.env` file for all services

`.env`

#### Jobcreator `darts jc` or `darts run`

- `WEB3_PRIVATE_KEY` or `DARTS_PRIVATE_KEY` or `JC_PRIVATE_KEY` _(Priority in case all are present in the same order)_
- `DARTS_SOLVER` <i>Optional (only for advanced setups)</i>

[//]: # "* `DARTS_MEDIATORS` <i>Optional "

#### Solver `darts solver`

- `SOLVER_PRIVATE_KEY`
- `SERVER_PORT` (the port the solver will listen on)
- `SERVER_URL` (the public http(s) endpoint of the solver)

#### Resource provider `darts rp`

- `RP_PRIVATE_KEY`
- `DARTS_SOLVER` <i>Optional (only for advanced setups)</i>

[//]: # "* `SERVICE_MEDIATORS`"
[//]: # "#### Mediator `darts mediator`"
[//]: #
[//]: # "* `MEDIATOR_PRIVATE_KEY` (copy `MEDIATOR_PRIVATE_KEY` from `prod.env`)"
[//]: # "* `DARTS_SOLVER` (copy `SOLVER_ADDRESS` from `prod.env`)"

Once you have created these files - you can upload them to the VM(s) you are going to run the services on.

### systemd files

Upload the various systemd files from the `systemd` folder to the VM(s) you are going to run the services on.
E.g.

```
sudo cp bacalhau.service /etc/systemd/system/
sudo cp solver.service /etc/systemd/system/
sudo cp mediator.service /etc/systemd/system/
sudo cp job-creator.service /etc/systemd/system/
sudo systemctl enable bacalhau
sudo systemctl enable solver
sudo systemctl enable job-creator
sudo systemctl enable mediator
```

```
sudo systemctl start bacalhau
```

Go to [https://gitlab.com/darts-network/darts/-/releases](https://gitlab.com/darts-network/darts/-/releases)

```
export LATEST_RELEASE="<latest release as per github releases>"
wget https://gitlab.com/darts-network/darts/-/releases/download/${LATEST_RELEASE}/darts-linux-amd64
chmod +x darts-linux-amd64
sudo mv darts-linux-amd64 /usr/local/bin/darts
```

```
sudo systemctl start solver
sudo systemctl start job-creator
sudo systemctl start mediator
```

You can now start and stop the various services using `systemd` and see logs using `journalctl`.

Make sure you start the solver first.

You can now set up multiple resource providers (RPs), e.g. with GPUs. Make sure you mint each one a separate key, e.g.
with metamask and the faucet. RPs will need `bacalhau` and `resource-provider{,-gpu}`.

## troubleshooting

### receive buffer size error

`failed to sufficiently increase receive buffer size`
See https://github.com/quic-go/quic-go/wiki/UDP-Receive-Buffer-Size for details. Fix for Linux:

```
sudo sysctl -w net.core.rmem_max=2500000
sudo sysctl -w net.core.wmem_max=2500000
```
