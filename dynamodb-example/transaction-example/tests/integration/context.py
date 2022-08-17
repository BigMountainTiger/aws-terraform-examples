import uuid

class LambdaContext:
  def __init__(self, function_name):
    self._function_name = function_name
    self._invoked_function_arn = "arn:aws:%s" % function_name
    self._aws_request_id = str(uuid.uuid4())

  @property
  def function_name(self):
    return self._function_name

  @property
  def invoked_function_arn(self):
    return self._invoked_function_arn

  @property
  def aws_request_id(self):
    return self._aws_request_id