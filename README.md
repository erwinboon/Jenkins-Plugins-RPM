# Jenkins Plugins RPM Repository

A Yum repository for Jenkins plugins. With dependencies.

`/etc/yum.repos.d/jenkinsplugins.repo`
```
[jenkinsplugins]
name=JenkinsPlugins
baseurl=https://jenkins.roidelapluie.be/yum/
gpgcheck=0
```

## Features

* Supports Plugins dependencies
* Support Jenkins code rependencies
* Support every plugins
* Updated twice a day
* Plugins are version-pinned in Jenkins

## Notes

* The packages do not restart your Jenkins server, you need to do it by hand
* Requires Jenkins installed from RPM
* Beware: if your plugin requires a higher version of Jenkins, the jenkins
  package will be updates

## Rebuilding this repo

To rebuild this project, you will need a Jenkins server with Docker and a
`/var/www/repo` directory writable by Jenkins. Changes will be needed to the
Jenkinsfile as well.

## How to switch to the Jenkins Plugins RPM ?

1. Install the repository
2. `yum install /var/lib/jenkins/plugins/*.jpi`
3. Restart Jenkins

