cd test/cli/package-test-simple || exit 1

../../../main/sorbet --silence-dev-message --stripe-packages --max-threads=0 --uniquely-defined-behavior --stripe-packages-hint-message="RUN SCRIPT HINT" . 2>&1
