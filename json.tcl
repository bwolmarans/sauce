set jt "
\[
    {
        \"id\": 2,
        \"name\": \"An ice sculpture\",
        \"price\": 12.50,
        \"tags\": \[\"cold\", \"ice\"\],
        \"dimensions\": {
            \"length\": 7.0,
            \"width\": 12.0,
            \"height\": 9.5
        },
        \"warehouseLocation\": {
            \"latitude\": -78.75,
            \"longitude\": 20.4
        }
    },
    {
        \"id\": 3,
        \"name\": \"A blue mouse\",
        \"price\": 25.50,
        \"dimensions\": {
            \"length\": 3.1,
            \"width\": 1.0,
            \"height\": 1.0
        },
        \"warehouseLocation\": {
            \"latitude\": 54.4,
            \"longitude\": -32.7
        }
    }
\]
"

#find the dimensions of the blue mouse
set name_to_find "blue mouse"
set new_name "red elephant"
#set nfl [string length $name_to_find]
#set x [string first $thing_to_find $jt]
regsub $name_to_find $jt $new_name jt2
puts $jt2
