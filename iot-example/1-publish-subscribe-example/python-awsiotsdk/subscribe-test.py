from awscrt import io, mqtt
from awsiot import mqtt_connection_builder

from endpoint import ENDPOINT
CLIENT_ID = "subscribe_device"
PATH_TO_CERTIFICATE = "../.cert/certificate.pem"
PATH_TO_PRIVATE_KEY = "../.cert/private.pem"
PATH_TO_AMAZON_ROOT_CA_1 = "../.cert/root.pem"
TOPIC = "test/testing"


event_loop_group = io.EventLoopGroup(1)
host_resolver = io.DefaultHostResolver(event_loop_group)
client_bootstrap = io.ClientBootstrap(event_loop_group, host_resolver)
mqtt_connection = mqtt_connection_builder.mtls_from_path(
    endpoint=ENDPOINT,
    cert_filepath=PATH_TO_CERTIFICATE,
    pri_key_filepath=PATH_TO_PRIVATE_KEY,
    client_bootstrap=client_bootstrap,
    ca_filepath=PATH_TO_AMAZON_ROOT_CA_1,
    client_id=CLIENT_ID,
    clean_session=False,
    keep_alive_secs=6
)

print(f"Connecting to {ENDPOINT} with client ID '{CLIENT_ID}'...")
connect_future = mqtt_connection.connect()
result = connect_future.result()
print(f'Connected! - {result}')


def CBack(topic, payload, **kwargs):
    print(f'{topic} - {payload}')


subscribe_future, packet_id = mqtt_connection.subscribe(
    topic=TOPIC, qos=mqtt.QoS.AT_LEAST_ONCE, callback=CBack)

subscribe_result = subscribe_future.result()
print(subscribe_result)

input("press any key to stop ...\n")
