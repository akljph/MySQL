# Company Employees

INSERT INTO `tblEmployee` (`employee_first_name`, `employee_last_name`, `employee_address`, `employee_emailid`, `employee_department_id`, `employee_joining_date`) VALUES
('Jane', 'Doe', 'Female', 'e6a33eee180b07e563d74fee8c2c66b8'),
('John', 'Doe', 'Male', '2e7dc6b8a1598f4f75c3eaa47958ee2f'),
('Sara', 'Smith', 'Male', '1c3a8e03f448d211904161a6f5849b68'),
('Sam', 'Smith', 'Male', '62f0a68a4179c5cdd997189760cbcf18'),;

stages:
  - deploy-stage

deploy-stage:
  stage: deploy-stage
  image: 
    name:  akeyless/ci_base
  before_script:
    - export DATA=akeyless://mysqlDS # MySQL Dynamic Secret
    - export RSA=akeyless://jeremy-demo # Private Key Static Secret
    - export REMOTE_HOST=akeyless://remote-host # Remote EC2 Host Static Secret
    - export VAULT_ADDR=https://hvp.akeyless.io
    - export TOKEN=$(akeyless auth --access-id p-4pyphbb1kpdd --access-type jwt --jwt $CI_JOB_JWT_V2) # Akeyless/Gitlab Authentication
    - source ~/.akeyless/akeyless_env.sh
    - export user=$(echo "$DATA" | jq -r .id) # Split Dynamic Secret to grab Username
    - export pass=$(echo "$DATA" | jq -r .password) # Split Dynamic Secret to grab Password
  script:
    - echo $RSA | base64 --decode >> jeremy-demo.pem # Add RSA Private Key into PEM file in container
    - chmod 600 jeremy-demo.pem
    - echo $RSA
    - echo $REMOTE_HOST
  # - ssh -o StrictHostKeyChecking=no -i "jeremy-demo.pem" ubuntu@$REMOTE_HOST -tt "source employees.sql;" # SSH into Remote EC2 Host and update DB
  # - echo "Database testdb updated!"

