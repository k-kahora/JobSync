export HCP_CLIENT_ID=zWlFvMBJ4MeKptGi1O9qARURipo5wJkd
export HCP_CLIENT_SECRET=Khxa2dgZyM0KcVKsFuaZWOIgy46WmdT3DnVfDIbcNZ8N6yvftLMfKnxB3hgYD0Nv
export AWS_PROFILE=admin # requires settin a sso profile with aws cli

packer build --var-file=vars.pkrvar.hcl golden.pkr.hcl
