create database biblioteca;
use biblioteca;

create table livros(
cod_livros int auto_increment primary key,
ISBN int (13),
titulo varchar (255),
subTitulo varchar (255),
anoPublicacao int (4),
genero varchar(100),
breve_descricao varchar (255)
);

alter table livros change ISBN ISBN bigint(13);

create table autores (
cod_autor int auto_increment primary key,
nomeCompleto varchar (255),
dtNasc date,
biografiaResumida varchar (255)
);

create table livrosXautores (
idx int auto_increment primary key,
cod_livro int, 
cod_autor int,
constraint fk_codLivro foreign key (cod_livro) references livros (cod_livros), 
constraint fk_codAutor foreign key (cod_autor) references autores (cod_autor)
);

create table usuarios (
cod_usuario int auto_increment primary key,
nomeCompleto varchar (255),
endereco varchar (255),
bairro varchar (100),
cidade varchar (100),
estado varchar (2)
);

alter table usuarios add column assinatura enum ("Aluno", "Professor", "Funcionario") default "Aluno";
insert into usuarios (nomeCompleto, assinatura) values ("Robson", "diretor");

select * from usuarios;

alter table usuarios change assinatura assinatura enum ("Aluno", "Professor", "Funcionario", "Diretor") default "Aluno";

create table usuariosXtelefones (
idx int auto_increment primary key,
idUsuario int,
telefone int (11),
constraint fk_idUsuario_tel foreign key (idUsuario) references usuarios (cod_usuario)
);

alter table usuariosXtelefones change telefone telefone bigint(11);

create table usuariosXemails (
idx int auto_increment primary key,
idUsuario int,
email varchar (255),
constraint fk_idUsuario_email foreign key (idUsuario) references usuarios (cod_usuario)
);

create table emprestimos(
id_emp int auto_increment primary key,
data_emp date not null,
data_devolucaoPrevista date not null,
data_devolucaoReal date,
id_usuario int,
constraint foreign key (id_usuario) references usuarios(cod_usuario)
);
 
create table empXlivros(
id int auto_increment primary key,
id_livro int,
id_emp int,
constraint foreign key (id_livro) references livros (cod_livros),
constraint foreign key (id_emp) references emprestimos (id_emp)
);

INSERT INTO livros (ISBN, titulo, subTitulo, anoPublicacao, genero, breve_descricao)
VALUES
(9780140449136, 'A Odisséia', 'Traduzido por: João Pereira', 800, 'Épico', 'A história épica de 
Odisseu e sua jornada de volta para casa.'),
(9780321125217, 'Clean Code', 'A Handbook of Agile Software Craftsmanship', 2008, 
'Tecnologia', 'Conselhos e melhores práticas para escrever código limpo e manutenível.'),
(9780201616224, 'Design Patterns', 'Elements of Reusable Object-Oriented Software', 1994, 
'Tecnologia', 'Padrões de design de software e suas aplicações em programação orientada a 
objetos.');

select * from livros;

INSERT INTO autores (nomeCompleto, dtNasc, biografiaResumida)
VALUES
('Homero', '0800-01-01', 'Poeta grego da Antiguidade, autor da Ilíada e da Odisséia.'),
('Robert C. Martin', '1952-12-05', 'Engenheiro de software e autor conhecido por seu trabalho 
em princípios de design de software.'),
('Erich Gamma', '1960-03-22', 'Um dos autores do famoso livro "Design Patterns", professor e 
consultor em design de software.');

select * from autores;

INSERT INTO livrosXautores (cod_livro, cod_autor)
VALUES
(1, 1), -- A Odisséia por Homero
(2, 2), -- Clean Code por Robert C. Martin
(3, 3); -- Design Patterns por Erich Gamma

select * from livrosXautores;

INSERT INTO usuarios (nomeCompleto, endereco, bairro, cidade, estado, assinatura)
VALUES
('Ana Silva', 'Rua das Flores, 123', 'Jardim Primavera', 'São Paulo', 'SP', 'Aluno'),
('João Souza', 'Avenida Central, 456', 'Centro', 'Rio de Janeiro', 'RJ', 'Professor'),
('Maria Oliveira', 'Praça da Liberdade, 789', 'Liberdade', 'Belo Horizonte', 'MG', 'Funcionario');

select * from usuarios;

INSERT INTO usuariosXtelefones (idUsuario, telefone)
VALUES
(6, 11987654321),
(7, 21987654321),
(8, 31987654321);

select * from usuariosXtelefones;

INSERT INTO usuariosXemails (idUsuario, email)
VALUES
(1, 'ana.silva@example.com'),
(2, 'joao.souza@example.com'),
(3, 'maria.oliveira@example.com');

select * from usuariosXemails;

INSERT INTO emprestimos (data_emp, data_devolucaoPrevista, data_devolucaoReal, id_usuario)
VALUES
('2024-08-01', '2024-08-15', NULL, 1),
('2024-08-05', '2024-08-20', NULL, 2),
('2024-08-10', '2024-08-25', NULL, 3);

select * from emprestimos;

INSERT INTO empXlivros (id_livro, id_emp)
VALUES
(1, 1), -- A Odisséia emprestado no empréstimo 1
(2, 2), -- Clean Code emprestado no empréstimo 2
(3, 3); -- Design Patterns emprestado no empréstimo 3

select * from empXlivros;

-- Listar todos os livros disponíveis na biblioteca.*/ 
select titulo from livros;

-- Encontrar todos os autores que têm mais de 50 anos.
select nomeCompleto from autores where dtNasc < '1976-12-31';

-- Mostrar todos os usuários que têm assinatura de 'Professor
select nomeCompleto from usuarios where assinatura = "Professor";

-- Listar todos os emprestimos que ainda não foram devolvidos.
select id_emp from emprestimos where data_devolucaoReal is null;

-- Exibir todos os livros junto com os nomes dos autores que os escreveram.
select l.titulo as "Título do Livro", a.nomeCompleto as "Autor" from livrosXautores
inner join livros l on livrosXautores.cod_livro = l.cod_livros
inner join autores a on livrosXautores.cod_autor = a.cod_autor; 

-- Mostrar todos os empréstimos com o nome do usuário que fez o empréstimo e o título do livro emprestado.
select l.titulo as "Título do Livro", u.nomeCompleto as "Nome do Usuário" from empXlivros
inner join livros l on empXlivros.id_livro = l.cod_livros
inner join emprestimos emp on empXlivros.id_emp = emp.id_emp
inner join usuarios u on emp.id_usuario = u.cod_usuario;

-- Listar todos os usuários e seus números de telefone.
select u.nomeCompleto as "Nome do Usuário", t.telefone as "Telefone do Usuário" from usuariosXtelefones
inner join usuarios u on usuariosXtelefones.idUsuario = u.cod_usuario
inner join usuariosXtelefones t on usuariosXtelefones.telefone = t.telefone;



-- 8 Mostrar todos os e-mails dos usuários que têm assinatura 'Funcionario'.
select email from usuariosXemails
inner join usuarios u on usuariosXemails.idUsuario = u.cod_usuario where assinatura = 'Funcionário';

create table usuariosXemails (
idx int auto_increment primary key,
idUsuario int,
email varchar (255),
constraint fk_idUsuario_email foreign key (idUsuario) references usuarios (cod_usuario)
);
 
-- 9.Encontrar todos os livros publicados após 2000 e ordená-los pelo ano de publicação.
select titulo from livros where ano_publicacao = 2008 order by ano_publicacao;
 
-- 10. Listar todos os autores cuja biografia contém a palavra 'design'.
select nome from autores where biografia like '%design%';
 
-- 11. Mostrar os detalhes dos empréstimos que foram feitos por usuários da cidade 'São Paulo'.
select * from emprestimos
inner join usuarios u on emprestimos.id_usuario = u.id_usuario where u.cidade = 'São Paulo';
 
-- 12.Contar o número de livros de cada gênero na biblioteca.
select genero, count(*) as num_livros from livros group by genero;
 
-- 13. Encontrar o autor com o maior número de livros na biblioteca.
select a.nome as autor, count(lxa.id_livro) as num_livros from livrosXautores lxa
inner join autores a on lxa.id_autores = a.id_autor
group by a.id_autor, a.nome order by num_livros desc limit 1;
 
-- 14. Mostrar todos os usuários que nunca fizeram um empréstimo. 
select * from usuarios u
left join emprestimos e on u.id_usuario = e.id_usuario
where e.id_usuario is null;
 
-- 15.Listar os livros que foram emprestados, mas ainda não foram devolvidos.
select l.* from livros l
inner join empXlivros exl on l.cod_livro = exl.id_livro
inner join emprestimos e on exl.id_emp = e.id_emp
where e.data_devolucaoReal is null;



