import paho.mqtt.client as paho
import threading
import json
import ssl
import time


from endpoint import ENDPOINT
PORT = 8883
CLIENT_ID = "publish_device"
PATH_TO_CERTIFICATE = "../.cert/certificate.pem"
PATH_TO_PRIVATE_KEY = "../.cert/private.pem"
PATH_TO_AMAZON_ROOT_CA_1 = "../.cert/root.pem"
MESSAGE = "Hello World"
TOPIC = "test/testing"


def run():
    lock = threading.Lock()
    client = paho.Client()
    connected = False

    def on_connect(client, userdata, flags, rc):
        nonlocal connected
        connected = True
        client.subscribe(topic=TOPIC, qos=1)
        print('Client is connected')

    def on_disconnect(client, userdata, rc):
        nonlocal connected
        connected = False
        print('Client is disconnected')

    def on_message(client, userdata, msg):
        print(f'{msg.topic} - {msg.payload} - received')

    client.on_connect = on_connect
    client.on_disconnect = on_disconnect

    def on_message(client, userdata, msg):
        print(f'{msg.topic} - {msg.payload} - received')

    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_message = on_message

    client.tls_set(
        ca_certs=PATH_TO_AMAZON_ROOT_CA_1,
        certfile=PATH_TO_CERTIFICATE,
        keyfile=PATH_TO_PRIVATE_KEY,
        cert_reqs=ssl.CERT_REQUIRED,
        tls_version=ssl.PROTOCOL_TLSv1_2,
        ciphers=None
    )

    result = client.connect(ENDPOINT, PORT, keepalive=60)
    client.loop_start()

    def publish_msg():

        while True:
            time.sleep(5)
            if not connected:
                continue

            message = {"message": MESSAGE}

            with lock:
                # https://github.com/eclipse/paho.mqtt.python/issues/354
                # publish may cause deadlock if called in different threads
                info = client.publish(
                    topic=TOPIC,
                    payload=json.dumps(message),
                    qos=0
                )

                info.wait_for_publish(3)
                print(f'Message publish - {info.is_published()}')

    threading.Thread(target=publish_msg, daemon=True).start()
    input("press any key to stop ...\n")

    client.loop_stop()
    client.disconnect()
    print('Client completed')


if __name__ == '__main__':
    run()
