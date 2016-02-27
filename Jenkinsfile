def plugins=[:]
node {
  git credentialsId: 'f8d7c9fa-085b-4c5c-b954-da175532823d', url: 'ssh://git@git.ethylix.be:2222/roidelapluie/jenkins.git'
  sh 'make dockerimage'
  sh 'make'
  sh 'find . -name "*.rpm" -exec cp -nv "{}" /var/www/repo ";"'
  sh 'createrepo /var/www/repo'
}
