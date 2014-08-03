# vim: ft=sh sw=2 ts=2 expandtab

# Java Home (default Java 8)
export JAVA_HOME=$([ -x /usr/libexec/java_home ] && /usr/libexec/java_home -v 1.8)

# simple java version management
jv() {
  case ${1} in
    6)
      export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
    ;;
    7)
      export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
    ;;
    8)
      export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0_05)
    ;;
    fast)
      export JAVA_OPTS="-d32 -client -Djruby.compile.mode=OFF"
    ;;
    big)
      export JAVA_OPTS="-Xmx1024m"
    ;;
    nopts)
      unset JAVA_OPTS
    ;;
    versions)
      /usr/libexec/java_home --verbose
     ;;
    help|-h|--help)
echo "
Helper to set/change java versions on OSX

Usage jv [ARG] where ARG can be:
6         set java to version 6
7         set java to version 7
8         set java to version 8
fast      set opts for fast startup
big       set opts for big max heap (1G)
nopts     unset opts to default
versions  shows current available versions
"
    ;;
  esac
  echo JAVA_OPTS=${JAVA_OPTS}
  echo JAVA_HOME=${JAVA_HOME}
  echo -n "Active: "
  java -version 2>&1 | grep version
}
