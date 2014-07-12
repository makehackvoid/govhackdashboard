require 'travis'
require 'dotenv'
Dotenv.load


data_id = 'ci_travis'
type_config = 'org'

def update_builds()
  builds = []
  repo = nil

  Travis.access_token = ENV['TRAVIS_AUTH_TOKEN']
  repo = Travis::Repository.find(ENV['TRAVIS_REPO'])

  build = repo.last_build
  build_info = {
    label: "Build #{build.number}",
    value: "[#{build.branch_info}], #{build.state} in #{build.duration}s",
    state: build.state
  }
  builds << build_info

  builds
end

SCHEDULER.every('1m', first_in: '1s') {
  builds = update_builds()
  send_event(data_id, { items: builds })
}
