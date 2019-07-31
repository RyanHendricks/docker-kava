#!/bin/sh


# exit script on any error
set -e
echo "setting up initial configurations"

if [ ! -f "$KVD_HOME/config/config.toml" ];
then

  kvd init ${MONIKER:-nonamenode} --home=${KVD_HOME:-/.kvd} --chain-id=${CHAIN_ID:-kava-testnet-2000}

  cd $KVD_HOME/config

  rm genesis.json
  rm config.toml

  if [ -z "$GENESIS_URL" ]; then
      wget $GENESIS_URL
  else
      wget https://raw.githubusercontent.com/Kava-Labs/kava-testnets/master/2000/genesis.json
  fi


cat > config.toml << EOF
# This is a TOML config file.
# For more information, see https://github.com/toml-lang/toml

##### main base config options #####

# TCP or UNIX socket address of the ABCI application,
# or the name of an ABCI application compiled in with the Tendermint binary
proxy_app = "tcp://0.0.0.0:${PROXY_APP_PORT:-26658}"

# A custom human readable name for this node
moniker = "${MONIKER:-moniker}"

# If this node is many blocks behind the tip of the chain, FastSync
# allows them to catchup quickly by downloading blocks in parallel
# and verifying their commits
fast_sync = ${FAST_SYNC:-true}

# Database backend: leveldb | memdb | cleveldb
db_backend = "${DB_BACKEND:-goleveldb}"

# Database directory
db_dir = "${DB_DIR:-data}"

# Output level for logging, including package level options
log_level = "${LOG_LEVEL:-main:info,state:info,*:error}"

##### additional base config options #####

# Path to the JSON file containing the initial validator set and other meta data
genesis_file = "${GENESIS_FILE:-config/genesis.json}"

# Path to the JSON file containing the private key to use as a validator in the consensus protocol
priv_validator_key_file = "${PRIV_VALIDATOR_KEY_FILE:-config/priv_validator_key.json}"

# Path to the JSON file containing the last sign state of a validator
priv_validator_state_file = "${PRIV_VALIDATOR_KEY_FILE:-data/priv_validator_state.json}"

# TCP or UNIX socket address for Tendermint to listen on for
# connections from an external PrivValidator process
priv_validator_laddr = "${PRIV_VALIDATOR_LADDR:-}"

# Path to the JSON file containing the private key to use for node authentication in the p2p protocol
node_key_file = "${NODE_KEY_FILE:-config/node_key.json}"

# Mechanism to connect to the ABCI application: socket | grpc
abci = "${ABCI:-socket}"

# TCP or UNIX socket address for the profiling server to listen on
prof_laddr = "${PROF_LADDR:-localhost:6060}"

# If true, query the ABCI app on connecting to a new peer
# so the app can decide if we should keep the connection or not
filter_peers = ${FILTER_PEERS:-false}

##### advanced configuration options #####

##### rpc server configuration options #####
[rpc]

# TCP or UNIX socket address for the RPC server to listen on
laddr = "tcp://0.0.0.0:${RPC_LADDR_PORT:-26657}"


# A list of origins a cross-domain request can be executed from
# Default value '[]' disables cors support
# Use '["*"]' to allow any origin
cors_allowed_origins = ["*"]

# A list of methods the client is allowed to use with cross-domain requests
cors_allowed_methods = ["HEAD", "GET", "POST"]

# A list of non simple headers the client is allowed to use with cross-domain requests
cors_allowed_headers = ["Origin", "Accept", "Content-Type", "X-Requested-With", "X-Server-Time"]



# TCP or UNIX socket address for the gRPC server to listen on
# NOTE: This server only supports /broadcast_tx_commit
grpc_laddr = "${GRPC_LADDR:-}"

# Maximum number of simultaneous connections.
# Does not include RPC (HTTP&WebSocket) connections. See max_open_connections
# If you want to accept more significant number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
# Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
# 1024 - 40 - 10 - 50 = 924 = ~900
grpc_max_open_connections = ${GRPC_MAX_OPEN_CONNECTIONS:-900}

# Activate unsafe RPC commands like /dial_seeds and /unsafe_flush_mempool
unsafe = ${UNSAFE:-false}

# Maximum number of simultaneous connections (including WebSocket).
# Does not include gRPC connections. See grpc_max_open_connections
# If you want to accept more significant number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
# Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
# 1024 - 40 - 10 - 50 = 924 = ~900
max_open_connections = ${MAX_OPEN_CONNECTIONS:-900}

# Maximum number of unique clientIDs that can /subscribe
# If you're using /broadcast_tx_commit, set to the estimated maximum number
# of broadcast_tx_commit calls per block.
max_subscription_clients = ${MAX_SUBSCRIPTION_CLIENTS:-100}

# Maximum number of unique queries a given client can /subscribe to
# If you're using GRPC (or Local RPC client) and /broadcast_tx_commit, set to
# the estimated # maximum number of broadcast_tx_commit calls per block.
max_subscriptions_per_client = ${MAX_SUBSCRIPTION_PER_CLIENT:-5}

# How long to wait for a tx to be committed during /broadcast_tx_commit.
# WARNING: Using a value larger than 10s will result in increasing the
# global HTTP write timeout, which applies to all connections and endpoints.
# See https://github.com/tendermint/tendermint/issues/3435
timeout_broadcast_tx_commit = "${TIMEOUT_BROADCAST_TX_COMMIT:-10s}"

# The name of a file containing certificate that is used to create the HTTPS server.
# If the certificate is signed by a certificate authority,
# the certFile should be the concatenation of the server's certificate, any intermediates,
# and the CA's certificate.
# NOTE: both tls_cert_file and tls_key_file must be present for Tendermint to create HTTPS server. Otherwise, HTTP server is run.
tls_cert_file = "${TLS_CERT_FILE:-}"

# The name of a file containing matching private key that is used to create the HTTPS server.
# NOTE: both tls_cert_file and tls_key_file must be present for Tendermint to create HTTPS server. Otherwise, HTTP server is run.
tls_key_file = "${TLS_KEY_FILE:-}"


##### peer to peer configuration options #####
[p2p]

# Address to listen for incoming connections
laddr = "tcp://0.0.0.0:${CONNECTIONS_LADDR_PORT:-26656}"

# Address to advertise to peers for them to dial
# If empty, will use the same port as the laddr,
# and will introspect on the listener or use UPnP
# to figure out the address.
external_address = "${EXTERNAL_ADDRESS:-}"

# Comma separated list of seed nodes to connect to
seeds = "${SEEDS:-}"

# Comma separated list of nodes to keep persistent connections to
persistent_peers = "${PERSISTENT_PEERS:-01257db868b80e97ab2500d6dbd4e363ea66bce9@167.71.82.149:26656,029bf9259159299abbce18f80d7b962f43c02cd8@52.15.93.51:26656,0904a1e6d35516ea0718816ad7a4f110be12fb8f@68.183.224.42:26656,0ecd8c1f77aff8ba7dbbebd70cdd9fd626329749@8.8.8.8:26656,0fa841ae1f35b91b14cd9ec2db99aa8310153955@178.128.32.37:26656,11152610962ae3e23ba2e6a7f5a5350060704184@18.139.99.9:26656,197f7180fc52324088b515b8df482a31b54c7868@167.86.115.5:26656,1a01541901f6936bbdfc9e03f5a962663fb975b4@93.95.97.150:26656,1b3c8a26dcad9f25e5ed3dce0ec2b6008955a7db@165.22.146.119:26656,209102c82dff760542418ff7d788b713307fc921@18.216.37.131:26656,21fc49e67fbe386b8271d30154fef414f639a3fc@51.158.122.124:26656,245509e8466b7b060224a053877fce9ec0306369@167.86.106.41:26656,273bc1610c63f6ba553ebf8873f0c795ff3e7b18@34.66.94.218:26656,280f083b6116f39eb648accec4f978ffa67d3d1f@51.15.93.243:26656,29c94aede0c41219df26b91220e2aefd43e70b0f@45.55.49.32:26656,2a63b430cac48d5697fb63545f235573523ccc0c@188.166.139.82:26656,31c88d42066c7edaff6f9cbd710a58bba39a0985@0.0.0.0:26656,32b44460828b309918a232329c142d94642fbd9d@37.97.134.67:26656,32db3fa755728c6f772cd901cc251539458f6922@159.203.64.155:26656,3964d2f8c6c9a0ab6441134d2d423e8fc8af6899@172.1.2.11:26656,3c27b6705d09de4d08de8b0c2eeaf9061439399a@136.244.101.33:26656,3cb42252419ff69afc611ba0c97bcbfb4c6c2e14@35.234.71.80:26656,3ccfba71f28a7ea68adb5492747be4f0422791c3@3.220.254.208:26656,3d3752c9fa7a82894b1252152fe4cfe0cb38789b@95.179.156.200:26656,41dbfb344a87d6e474832fc93243ef2154120115@51.144.77.250:26656,43be2d026aae1df084cf17ab2da3bfe1c1e3c934@10.6.0.127:26656,4a1f6f071f818af4b4d4b4a3ff4e682a4da4f5f4@31.221.59.204:26656,4ab1e0b762629372347c7cc0fdd5735516262f65@45.55.121.154:26656,4af583f8cae0367552688a46ef936f6f5b77d430@66.42.78.17:26656,4b35c4a290b75cdab6e0da17907be1810c0db342@51.254.143.228:26656,4c0fa334c3b373c2286eb8822270a0c3cde60379@45.32.7.141:26656,51ea1e5b1d488a77cb55818859a8e41896046642@18.213.218.58:26656,5303e017f074888e4f321de27fc07064259d99d4@95.216.175.140:26656,56ac2b77d24cd4bf2cbe1533031a709d1aa8df07@52.205.177.149:26656,584c17d748114c7d6894b927f5a9f6fcc688ae08@13.59.63.136:26656}"

# UPNP port forwarding
upnp = ${UPNP:-false}

# Path to address book
addr_book_file = "${ADDR_BOOK_FILE:-config/addrbook.json}"

# Set true for strict address routability rules
# Set false for private or local networks
addr_book_strict = ${ADDR_BOOK_STRICT:-false}

# Maximum number of inbound peers
max_num_inbound_peers = ${MAX_NUM_INBOUND_PEERS:-40}

# Maximum number of outbound peers to connect to, excluding persistent peers
max_num_outbound_peers = ${MAX_NUM_OUTBOUND_PEERS:-40}

# Time to wait before flushing messages out on the connection
flush_throttle_timeout = "${FLUSH_THROTTLE_TIMEOUT:-100ms}"

# Maximum size of a message packet payload, in bytes
max_packet_msg_payload_size = ${MAX_PACKET_MSG_PAYLOAD_SIZE:-5000}

# Rate at which packets can be sent, in bytes/second
send_rate = ${SEND_RATE:-10240000}

# Rate at which packets can be received, in bytes/second
recv_rate = ${RECV_RATE:-10240000}

# Set true to enable the peer-exchange reactor
pex = ${PEX:-true}

# Seed mode, in which node constantly crawls the network and looks for
# peers. If another node asks it for addresses, it responds and disconnects.
#
# Does not work if the peer-exchange reactor is disabled.
seed_mode = ${SEED_MODE:-false}

# Comma separated list of peer IDs to keep private (will not be gossiped to other peers)
private_peer_ids = "${PRIVATE_PEER_IDS:-}"

# Toggle to disable guard against peers connecting from the same ip.
allow_duplicate_ip = ${ALLOW_DUPLICATE_IP:-true}

# Peer connection configuration.
handshake_timeout = "${HANDSHAKE_TIMEOUT:-20s}"
dial_timeout = "${DIAL_TIMEOUT:-3s}"

##### mempool configuration options #####
[mempool]

recheck = ${RECHECK:-true}
broadcast = ${BROADCAST:-true}
wal_dir = "${WAL_DIR}"

# size of the mempool
size = ${SIZE_OF_MEMPOOL:-5000}

# This only accounts for raw transactions (e.g. given 1MB transactions and
# max_txs_bytes=5MB, mempool will only accept 5 transactions).
max_txs_bytes = ${MAX_TXS_BYTES:-1073741824}


# size of the cache (used to filter transactions we saw earlier)
cache_size = ${CACHE_SIZE:-10000}

##### consensus configuration options #####
[consensus]

wal_file = "${WAL_FILE:-data/cs.wal/wal}"

timeout_propose = "${TIMEOUT_PROPOSE:-3s}"
timeout_propose_delta = "${TIMEOUT_PROPOSE_DELTA:-500ms}"
timeout_prevote = "${TIMEOUT_PREVOTE:-1s}"
timeout_prevote_delta = "${TIMEOUT_PREVOTE_DELTA:-500ms}"
timeout_precommit = "${TIMEOUT_PRECOMMIT:-1s}"
timeout_precommit_delta = "${TIMEOUT_PRECOMMIT_DELTA:-500ms}"
timeout_commit = "${TIMEOUT_COMMIT:-5s}"


# Make progress as soon as we have all the precommits (as if TimeoutCommit = 0)
skip_timeout_commit = ${SKIP_TIMEOUT_COMMIT:-false}

# EmptyBlocks mode and possible interval between empty blocks
create_empty_blocks = ${CREATE_EMPTY_BLOCKS:-true}
create_empty_blocks_interval = "${CREATE_EMPTY_BLOCKS_INTERVAL:-0s}"

# Reactor sleep duration parameters
peer_gossip_sleep_duration = "${PEER_GOSSIP_SLEEP_DURATION:-100ms}"
peer_query_maj23_sleep_duration = "${PEER_QUERY_MAJ23_SLEEP_DURATION:-2s}"

##### transactions indexer configuration options #####
[tx_index]

# What indexer to use for transactions
#
# Options:
#   1) "null" (default)
#   2) "kv" - the simplest possible indexer, backed by key-value storage (defaults to levelDB; see DBBackend).
indexer = "${INDEXER:-kv}"

# Comma-separated list of tags to index (by default the only tag is "tx.hash")
#
# You can also index transactions by height by adding "tx.height" tag here.
#
# It's recommended to index only a subset of tags due to possible memory
# bloat. This is, of course, depends on the indexer's DB and the volume of
# transactions.
index_tags = "${INDEX_TAGS:-tx.height,tx.hash,tx.events,tx.data,tx.info}"

# When set to true, tells indexer to index all tags (predefined tags:
# "tx.hash", "tx.height" and all tags from DeliverTx responses).
#
# Note this may be not desirable (see the comment above). IndexTags has a
# precedence over IndexAllTags (i.e. when given both, IndexTags will be
# indexed).
index_all_tags = ${INDEX_ALL_TAGS:-true}

##### instrumentation configuration options #####
[instrumentation]

# When true, Prometheus metrics are served under /metrics on
# PrometheusListenAddr.
# Check out the documentation for the list of available metrics.
prometheus = ${PROMETHEUS:-false}

# Address to listen for Prometheus collector(s) connections
prometheus_listen_addr = "${PROMETHEUS_LISTEN_ADDR:-0.0.0.0:26660}"

# Maximum number of simultaneous connections.
# If you want to accept more significant number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
max_open_connections = ${MAX_OPEN_CONNECTIONS:-3}

# Instrumentation namespace
namespace = "${NAMESPACE:-tendermint}"


EOF



cd $KVD_HOME

  # if [ "$BOOTSTRAP" == "TRUE" ]; then
  #   wget https://storage.googleapis.com/a2h-node-bootstraps/$CHAIN_ID.tar.lz4
  #   lz4 -d -v --rm $CHAIN_ID.tar.lz4 | tar xf -
  # fi

fi


if [ ! -z "$LCD_PORT" ]; then
    rm /etc/supervisor/conf.d/supervisor-kvcli.conf
    cd /etc/supervisor/conf.d/

cat > supervisor-kvcli.conf << EOF
[program:kvcli]
command=kvcli rest-server --laddr tcp://0.0.0.0:${LCD_PORT:-1317} --home=${KVD_HOME:-/.kvd} --trust-node --node=tcp://localhost:${RPC_LADDR_PORT:-26657} --cors="${CORS_ALLOWED_ORIGINS:-*}"
redirect_stderr=true
EOF

fi

exec supervisord --nodaemon --configuration /etc/supervisor/supervisord.conf
