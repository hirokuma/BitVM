Before running the demo for the first time, see [Environment Setup](#environment-setup) section below.

# Demo Prep: Funding UTXOs
The bridge peg-in and peg-out execution consumes three funding UTXOs. For convenience, prepare them before running the demo. This process remains the same across all scenarios.

The minimum required UTXO amounts may change in the future, so please use the **get-funding-amounts** CLI command to get up-to-date information. The list below is provided for reference only:

1. Peg-in graph - 'peg-in deposit' tx input: **2097447 SAT** - will be spent by [DEPOSITOR] (use `-d` to get their address)
2. Peg-out graph - 'peg-out confirm' tx input: **3607030 SAT** - will be spent by [OPERATOR] (use `-o` to get their address)
3. Withdrawer peg-out - 'peg-out' tx input: **2097274 SAT** - will be spent by [OPERATOR] (use `-o` to get their address)

# Demo Steps
The following is the list of command line arguments that are passed to the CLI tool in sequence by the respective actors. The arguments can be used either with `cargo run --bin bridge --` or when running the CLI binary directly.

## Rejected Disprove Scenario (a.k.a. 'happy peg-out' execution path).
#### [DEPOSITOR] Initiate peg-in
`<TXID>:<VOUT>` = Bridge deposit UTXO that includes the expected peg-in amount. It must be spendable by the depositor private key. Suggested test amount: `2097447 sats`. It is the UTXO #1 in [Demo Prep](#demo-prep-funding-utxos).
```
-n -u <TXID>:<VOUT> -d <EVM_ADDRESS>
```
#### [OPERATOR] Create peg-out graph
`<TXID>:<VOUT>` = UTXO funding the peg-out confirm tx. Must be spendable by the operator private key. Suggested test amount: `3562670 sats`. It is the UTXO #2 in [Demo Prep](#demo-prep-funding-utxos).
```
-t -u <TXID>:<VOUT> -i <PEG_IN_GRAPH_ID>
```
#### [VERIFIER_0] Push verifier_0 nonces for peg-in graph
```
-c -i <GRAPH_ID>
```
#### [VERIFIER_1] Push verifier_1 nonces for peg-in graph
```
-c -i <GRAPH_ID>
```
#### [VERIFIER_0] Push verifier_0 signatures for peg-in graph
```
-g -i <GRAPH_ID>
```
#### [VERIFIER_1] Push verifier_1 signatures for peg-in graph
```
-g -i <GRAPH_ID>
```
#### [OPERATOR] or [VERIFIER_0] or [VERIFIER_1] Broadcast peg-in confirm
```
-b pegin -g <PEG_IN_GRAPH_ID> confirm
```
Record the peg-in confirm txid.
#### [VERIFIER_0] Push verifier_0 nonces for peg-out graph
```
-c -i <GRAPH_ID>
```
#### [VERIFIER_1] Push verifier_1 nonces for peg-out graph
```
-c -i <GRAPH_ID>
```
#### [VERIFIER_0] Push verifier_0 signatures for peg-out graph
```
-g -i <GRAPH_ID>
```
#### [VERIFIER_1] Push verifier_1 signatures for peg-out graph
```
-g -i <GRAPH_ID>
```
#### [OPERATOR] Mock L2 peg-out event (requires peg-in confirm txid mined earlier)
> [!IMPORTANT]
> Start the CLI in interactive mode here.

`<TXID>:<VOUT>` = The peg-in confirm txid recorded above and output index 0.
```
-x -u <TXID>:<VOUT>
```
#### [OPERATOR] Broadcast peg-out
`<TXID>:<VOUT>` = UTXO funding the payout to the withdrawer. Must be spendable by the operator private key. Suggested test amount: `2097274 sats`. It is the UTXO #3 in [Demo Prep](#demo-prep-funding-utxos).
```
-b tx -g <GRAPH_ID> -u <TXID>:<VOUT> peg_out
```
#### [OPERATOR] Broadcast peg-out confirm
```
-b tx -g <GRAPH_ID> peg_out_confirm
```
#### [OPERATOR] Broadcast kick-off 1
```
-b tx -g <GRAPH_ID> kick_off_1
```
#### [OPERATOR] Broadcast kick-off 2
```
-b tx -g <GRAPH_ID> kick_off_2
```
#### [VERIFIER_1] Broadcast disprove (should fail)
`<BTC_ADDRESS>` = Receiver of the disprove reward.
```
-b tx -g <GRAPH_ID> -a <BTC_ADDRESS> disprove
```
#### [OPERATOR] Broadcast take 1
```
-b tx -g <GRAPH_ID> take_1
```

## Successful Disprove Scenario (a.k.a. 'unhappy peg-out' execution path).

⚠まだテストしていない

#### [DEPOSITOR] Initiate peg-in
`<TXID>:<VOUT>` = Bridge deposit UTXO that includes the expected peg-in amount. It must be spendable by the depositor private key. Suggested test amount: `2097447 sats`.
```
-n -u <TXID>:<VOUT> -d <EVM_ADDRESS>
```
#### [OPERATOR] Create peg-out graph
`<TXID>:<VOUT>` = UTXO funding the peg-out confirm tx. Must be spendable by the operator private key. Suggested test amount: `3562670 sats`.
```
-t -u <TXID>:<VOUT> -i <PEG_IN_GRAPH_ID>
```
#### [VERIFIER_0] Push verifier_0 nonces for peg-in graph
```
-c -i <GRAPH_ID>
```
#### [VERIFIER_1] Push verifier_1 nonces for peg-in graph
```
-c -i <GRAPH_ID>
```
#### [VERIFIER_0] Push verifier_0 signatures for peg-in graph
```
-g -i <GRAPH_ID>
```
#### [VERIFIER_0] Push verifier_1 signatures for peg-in graph
```
-g -i <GRAPH_ID>
```
#### [OPERATOR] or [VERIFIER_0] or [VERIFIER_1] Broadcast peg-in confirm
```
-b pegin -g <PEG_IN_GRAPH_ID> confirm
```
Record the peg-in confirm txid.
#### [VERIFIER_0] Push verifier_0 nonces for peg-out graph
```
-c -i <GRAPH_ID>
```
#### [VERIFIER_1] Push verifier_1 nonces for peg-out graph
```
-c -i <GRAPH_ID>
```
#### [VERIFIER_0] Push verifier_0 signatures for peg-out graph
```
-g -i <GRAPH_ID>
```
#### [VERIFIER_1] Push verifier_1 signatures for peg-out graph
```
-g -i <GRAPH_ID>
```
#### [OPERATOR] Mock L2 peg-out event (requires peg-in confirm txid mined earlier)
> [!IMPORTANT]
> Start the CLI in interactive mode here.

`<TXID>:<VOUT>` = The peg-in confirm txid recorded above and output index 0.
```
-x -u <TXID>:<VOUT>
```
#### [OPERATOR] Broadcast peg-out
`<TXID>:<VOUT>` = UTXO funding the payout to the withdrawer. Must be spendable by the operator private key. Suggested test amount: `2097274 sats`.
```
-b tx -g <GRAPH_ID> -u <TXID>:<VOUT> peg_out
```
#### [OPERATOR] Broadcast peg-out confirm
```
-b tx -g <GRAPH_ID> peg_out_confirm
```
#### [OPERATOR] Broadcast kick-off 1
```
-b tx -g <GRAPH_ID> kick_off_1
```
#### [OPERATOR] Broadcast kick-off 2
```
-b tx -g <GRAPH_ID> kick_off_2
```
#### [OPERATOR] Broadcast assert-initial
```
-b tx -g <GRAPH_ID> assert_initial
```
#### [OPERATOR] Broadcast assert-commit 1 with invalid proof
```
-b tx -g <GRAPH_ID> assert_commit_1_invalid
```
#### [OPERATOR] Broadcast assert-commit 2 with invalid proof
```
-b tx -g <GRAPH_ID> assert_commit_2_invalid
```
#### [OPERATOR] Broadcast assert-final
```
-b tx -g <GRAPH_ID> assert_final
```
#### [VERIFIER_1] Broadcast disprove
`<BTC_ADDRESS>` = Receiver of the disprove reward.
```
-b tx -g <GRAPH_ID> -a <BTC_ADDRESS> disprove
```

# Environment Setup
Clone and build this repository. The CLI executable is called `bridge`.

## [DEPOSITOR] and [OPERATOR] and [VERIFIER_0]
All the above users can execute commands using a single setup (from the same directory).

## [VERIFIER_1]
Install the CLI tool in a different directory and make sure it doesn't share the `.env` file with the setup above. You can either clone this repository at another location or just copy the binary along with the .env.

## This Environment

### Build `bridge`
Build in debug mode instead of release mode to make the data store local.

```shell
$ cargo build
```

### Run Bitcoin Regtest and Esplora

[regtest/README.md](regtest/README.md)

Run start.sh to generate blocks periodically.  
To change the update interval, change `REGTEST_BLOCK_TIME` in the `/.env.test` file.

```shell
$ cd regtest
$ ./install.sh
$ ./start.sh
```

Use cli.sh to send Bitcoin to an address.

```shell
$ cd regtest
$ ./cli.sh sendtoaddress <ADDRESS> <BTC amount>
```

You can view the blocks and transactions in your browser.

[http://localhost:8094/regtest/](http://localhost:8094/regtest/)

### Data Store settings

BitVM data store support AWS S3 / FTP(S) / SFTP / 'Local'.  
Use 'Local' in this environment.

### Terminals

#### user0

For DEPOSITOR, OPERATOR, VERIFIER_0

```console
$ cd user0
$ source prepare.sh
$ ./clear.sh
```

#### user1

For VERIFIER_1

```console
$ cd user1
$ source prepare.sh
$ ./clear.sh
```
