install:
	pip install --upgrade pip &&\
	pip install -r requirements.txt
	
test:
	python -m pytest --vv --cov=aws-ml-devops hello_test.py
	#python -m pytest --nbval notebook.ipynb
	
lint:
	pylint --disable=R,C hello hello.py
	
all: install lint test