PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(abspath $(PROJECT_DIR)/scripts/makeops/system-detect/init.mk)

# ==============================================================================

detect: ### Detect operating system info
	./scripts/makeops/system-detect/system.sh

test: ### Run the test suite
	./scripts/makeops/system-detect/system.test.sh

# ==============================================================================

.SILENT: \
	detect \
	test
