.PHONY: tests

TEST_FILES := $(shell find t -type f -name '*.pl')

tests:
	@prove -v -e 'swipl -q -t main -s' $(TEST_FILES)  
