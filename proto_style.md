# Proto Standard
 this standard fellows [google proto buffer style](https://developers.google.com/protocol-buffers/docs/style)
 
## File name
 use underscore_separated_names.
 for example: 
 ```
 test_proto_file.proto
 ```
 
## Services
 you should use CamelCase (with an initial capital) for both the service name and any RPC method names.
 for example:
 ```
 service FooService {
   rpc GetSomething(FooRequest) returns (FooResponse);
 }
 ```
 
## Message 
 Use CamelCase for message name, use underscore_separated_names for filed names.
 for example:
 ```
 message SongServerRequest {
   required string song_name = 1;
 }
 ```
 
## enums
Use CamelCase for enums name, use CAPITALS_WITH_UNDERSCORES for value names in it.
for example:
```
enum Foo {
  FIRST_VALUE = 1;
  SECOND_VALUE = 2;
}
```
