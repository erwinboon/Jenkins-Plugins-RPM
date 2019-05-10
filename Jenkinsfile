def plugins=[:]
node {
  git credentialsId: 'jenkins-id-4git', url: 'ssh://git@github.com/erwinboon/Jenkins-Plugins-RPM.git'
  sh 'make dockerimage'
  sh 'make'
  sh 'find . -name "*.rpm" -exec cp -nv "{}" /srv/www/yumrepo ";"'
  sh 'createrepo /srv/www/yumrepo'
}
