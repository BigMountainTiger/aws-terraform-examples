import logging

logging.basicConfig(level=logging.INFO)
log = logging.getLogger()
log.setLevel(logging.INFO)


if __name__ == '__main__':
    log.info('Job succeeded by default')
