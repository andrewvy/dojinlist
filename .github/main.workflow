workflow "New workflow" {
  on = "push"
  resolves = ["Check Formatting front-end"]
}

action "Check Formatting front-end" {
  uses = "actions/npm@v2.0.0"
  runs = "cd front-end && npx prettier --check --no-semi --single-quote *.js"
}
