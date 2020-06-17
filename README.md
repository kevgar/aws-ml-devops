[![CircleCI](https://circleci.com/gh/kevgar/aws-ml-devops.svg?style=svg)](https://circleci.com/gh/kevgar/aws-ml-devops)
# aws-ml-devops

AWS DevOps workflow for ML

## Steps to run this project
1. Create a repo for the project
2. Create a Cloud9 environment for the project
3. Generate an SSH key in the Cloud9 shell using the command: `ssh-keygen -t rsa`
4. Upload the SSH public key into Github
5. Clone into the repo in the Cloud9 shell using the command: `git clone [SSH link]`
6. Create scaffolding for the project
    * Makefile
    * requirements.txt

`Makefile`

    install:
        pip install --upgrade pip &&\
        pip install -r requirements.txt
		
    test:
        #python -m pytest --vv --cov=aws-ml-devops hello_test.py
        #python -m pytest --nbval notebook.ipynb
        
    lint:
        pylint --disable=R,C hello hello.py
        
    all: install lint test

`requirements.txt`

    lint
    pytest
    
7. Create a python virtual environment and source it if not created.  
    
        python3 -m venv ~/.aws-ml-devops  
        source ~/.aws-ml-devops/bin/activate

8. Add alias to `~/.bashrc` file. 

        echo 'alias aws-ml-devops="cd /home/ec2-user/environment/aws-ml-devops && source ~/.aws-ml-devops/bin/activate"' >> ~/.bashrc
        source ~/.bashrc

9. Create initial `hello.py` and `hello_test.py` file.

`hello.py`  

    def toyou(x):
    return "hi %s" % x


    def add(x):
        return x + 1
    
    
    def subtract(x):
        return x - 1
        
`hello_test.py`
    
    from hello import toyou, add, subtract
    
    def setup_function(function):
        print(" Running Setup: %s " % function.__name__)
        function.x = 10
    
    def teardown_function(function):
        print(" Running Teardown:%s" % function.__name__)
        del function.x
    
    ### Run to see failed test
    #def test_hello_add():
    #    assert add(test_hello_add.x) == 12
    
    def test_hello_subtract():
        assert subtract(test_hello_subtract.x) == 9

10. Run `make all` which will install, lint and test code.

11. Add new project in CircleCI
12. Create `.circleci/config.yml` file

        version: 2.1
        jobs:
          build:
            docker:
              - image: circleci/python:3.6.1
              
            working_directory: ~/aws-ml-devops
            
            steps: 
              - checkout
              - restore_cache:
                  keys:
                    - v1-dependencies-{{ checksum "requirements.txt" }}
                    - v1-dependencies-
              - run:
                  name: install dependencies
                  command: |
                    python3 -m venv venv
                    . venv/bin/activate
                    make install
              - save_cache:
                  paths:
                    - ./venv
                  key: v1-dependencies-{{ checksum "requirements.txt" }}
              - run:
                  name: run lint
                  command: |
                    . venv/bin/activate
                    make lint
                    
13. Add CircleCI status to README.
14. Push changes to Github.