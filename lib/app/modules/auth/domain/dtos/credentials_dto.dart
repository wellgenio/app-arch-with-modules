class CredentialsDto {
  String email;
  String password;

  CredentialsDto({required this.email, required this.password });

  factory CredentialsDto.empty() => CredentialsDto(
    password: '',
    email: '',
  );

  factory CredentialsDto.testUser() => CredentialsDto(
    password: '123456',
    email: 'test@gmail.com',
  );


  setEmail(String value) => email = value;

  setPassword(String value) => password = value;
}