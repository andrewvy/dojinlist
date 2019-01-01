use Mix.Config

config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_Env("AWS_SECRET_ACCESS_KEY"), :instance_role]
