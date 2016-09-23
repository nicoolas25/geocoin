$LOAD_PATH.unshift("./lib") unless $LOAD_PATH.include?("./lib")

require_relative "web"

run GeocoinApp
