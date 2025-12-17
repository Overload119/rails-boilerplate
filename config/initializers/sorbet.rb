# typed: strict
# frozen_string_literal: true

StringKeyHash = T.type_alias { T::Hash[String, T.untyped] }
SymbolKeyHash = T.type_alias { T::Hash[Symbol, T.untyped] }
