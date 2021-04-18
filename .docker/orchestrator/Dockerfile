ARG DOCKER_SERVER_HOST
ARG DOCKER_SERVER_PORT
ARG DOCKER_PROJECT_PATH
ARG DOCKER_IMAGE_VERSION=master

FROM ${DOCKER_SERVER_HOST}:${DOCKER_SERVER_PORT}/${DOCKER_PROJECT_PATH}/base:${DOCKER_IMAGE_VERSION}


STOPSIGNAL SIGINT

CMD [ "sh", "-c",  \
    "orchestrator", \
    "--cosmos-phrase=\"${ORCHESTRATOR_COSMOS_PHRASE}\"", \
    "--ethereum-key=\"${ORCHESTRATOR_ETHEREUM_KEY}\"", \
    "--cosmos-legacy-rpc=\"${ORCHESTRATOR_COSMOS_LEGACY_RPC}\"", \
    "--cosmos-grpc=\"${ORCHESTRATOR_COSMOS_GRPC}\"", \
    "--ethereum-rpc=\"${ORCHESTRATOR_ETHEREUM_RPC}\"", \
    "--fees=\"${ORCHESTRATOR_FEES}\"", \
    "--contract-address=\"${ORCHESTRATOR_CONTRACT_ADDRESS}\"" \
]








