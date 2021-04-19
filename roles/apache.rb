{
    "name": "web",
    "description": "my sample role",
    "json_class": "Chef::Role",
  
    "default_attributes": {
      "var1": "some-value-1"
    },
  
    "run_list": [
      "recipe[apache]" 
    ]
}