# https://docs.aws.amazon.com/apigateway/latest/developerguide/models-mappings-models.html

locals {
  get_query_params = {
    "method.request.querystring.param1" = true
    "method.request.querystring.param2" = true
  }

  get_response_schema = jsonencode({
    type : "object",
    properties : {
      metadata : {
        type : "object",
        properties : {
          a : {
            type : "string"
          },
          b : {
            type : "integer"
          },
          c : {
            type : "number"
          },
          d : {
            type : "boolean"
          }
        }
      },
      data : {
        type : "array",
        items : {
          type : "object",
          properties : {
            Role : {
              type : "string"
            },
            Policy : {
              type : "string"
            }
          }
        }
      }
    }
  })
}
