workflow "Test GitHub Pages Deployment" {
  on = "deployment"
  resolves = ["maddox/actions/wait-for-200@master"]
}

action "maddox/actions/wait-for-200@master" {
  uses = "maddox/actions/wait-for-200@master"
  env = {
    URL = "https://troyswanson.me/"
  }
}
