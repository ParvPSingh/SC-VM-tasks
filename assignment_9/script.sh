#!/bin/bash

class="$1"
feature="$2"

if [[ "$class" == "setosa" ]]; then
  class_name="Iris-setosa"
elif [[ "$class" == "versicolor" ]]; then
  class_name="Iris-versicolor"
elif [[ "$class" == "virginica" ]]; then
  class_name="Iris-virginica"
else
  echo "Invalid class argument: $class"
  exit 1
fi

if [[ "$feature" == "sepal_length" ]]; then
  feature_name="Sepal length"
  col=2
elif [[ "$feature" == "sepal_width" ]]; then
  feature_name="Sepal width"
  col=3
elif [[ "$feature" == "petal_length" ]]; then
  feature_name="Petal length"
  col=4
elif [[ "$feature" == "petal_width" ]]; then
  feature_name="Petal width"
  col=5
else
  echo "Invalid feature argument: $feature"
  exit 1
fi

mean=$(sqlite3 /opt/iris/iris-flower.sqlite3 "SELECT AVG($feature) FROM iris WHERE class='$class_name';")

printf '{"class":"%s","feature":"%s","mean":%.3f}\n' "$class_name" "$feature_name" "$mean"
