def plugins=[:]
node {
  git credentialsId: 'jenkins-id-4git', url: 'ssh://git@git.ethylix.be:2222/roidelapluie/jenkins.git'
  sh 'make dockerimage'
  sh 'make'
  sh 'find . -name "*.rpm" -exec cp -nv "{}" /srv/www/repo ";"'
  sh 'createrepo /srv/www/repo'
}
