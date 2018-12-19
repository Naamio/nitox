workflow "Build and test on push" {
  on = "push"
  resolves = ["Nitox Test Suite"]
}

action "Filter by tag" {
  uses = "actions/bin/filter@e96fd9a"
  args = "tag"
}

action "Build Nitox" {
  uses = "actions/docker/cli@76ff57a"
  args = "build -t yellowinnovation/nitox ."
  needs = ["Filter by tag"]
}

action "NATS" {
  uses = "actions/docker/cli@76ff57a"
  args = "run nats"
  needs = ["Build Nitox"]
}

action "Nitox Test Suite" {
  uses = "actions/docker/cli@76ff57a"
  needs = ["NATS"]
  args = "run yellowinnovation/nitox \"cargo test --release\""
}
