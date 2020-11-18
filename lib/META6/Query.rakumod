
unit package META6::Query:auth<github:littlebenlittle>:ver<0.0.0>;

#| search parent directories recursively until META6.json is found
our sub root-dir(IO() $start-dir -->IO()) {
    return $start-dir if $start-dir.d and 'META6.json' ∈ $start-dir.dir».basename;
    return root-dir($start-dir.dirname);
}
