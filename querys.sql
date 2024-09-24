create database bd_fatec;
use bd_fatec;

create table alunos (
idAluno int auto_increment primary key, 
nome varchar(100), 
cpf varchar(14)
);

insert into alunos (nome, cpf) values ("Pedro", "123.456.789-01"), ("Isa", "987.654.432-01"), ("lucas", "456.456.456-01");

# Seleção de todos os registros da tabela
select * from alunos;

# Seleção de todos os registros mostrando apenas alguns campos criados na tabela
select nome, cpf from alunos;

# Seleção de Registro específico
select * from alunos where idAluno=2;

# Atualizando dados em tabela
update alunos set cpf="123.456.789-01" where idAluno=2;

#Adicionar Campos na tabela
alter table alunos add column rg varchar (13);
select * from alunos;

alter table alunos add column tel varchar (14);
select * from alunos;

# Mudar nome do campo
alter table alunos change tel celular varchar (14);

# Apagar uma coluna
alter table alunos drop column rg;

# apelidos de campos (muda nome apenas na exibição)
select idAluno as ID, nome as "Nome do Aluno", cpf as CPF, celular as Telefone from alunos;

# Apelido da Tabela
/*select alunos.nome, alunos.cpf from alunos;*/
select a.nome, a.cpf from alunos a;

create table disciplinas(
idDisc int auto_increment primary key,
nomeDisc varchar (100)
);

insert into disciplinas (nomeDisc) values 
("Banco de Dados Relacional"),
("Desenvolvimento Web II"),
("Design Digital");

create table matricula (
idMatricula int auto_increment primary key,
aluno int,
disciplinas int,
#criar chave estrangeira
constraint fk_aluno_disciplina foreign key (aluno) references alunos (idAluno),
foreign key (disciplinas) references disciplinas (idDisc)
);

insert into matricula (aluno, disciplinas) values
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 3),
(3, 1);

select * from matricula;
select aluno, disciplinas from matricula where aluno=1;

# Relacionamento entre tabelas usando INNER JOIN
select a.nome as "Nome do Aluno", d.nomeDisc as "Disciplina" from matricula
inner join alunos a on matricula.aluno = a.idAluno
inner join disciplinas d on matricula.disciplinas = d.idDisc where matricula.Aluno = 2; 
