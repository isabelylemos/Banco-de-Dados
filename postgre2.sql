create table Autores(
	autor_id serial primary key,
	nome varchar(100)
);

create table livros(
	livro_id serial primary key,
	titulo varchar(150),
	autor_id int references Autores(autor_id) ON DELETE CASCADE,
	estoque int check (estoque >=0) , -- valida que o estoque não pode ficar negativo   
	ano_publicacao int,
	isbn varchar (13) unique -- determina que o registro será unico
);

create table Membros (
	membro_id serial primary key,
	nome varchar (100),
	endereco varchar (100),
	email varchar (100),
	data_cadastro date default current_date
);

create table emprestimos(
	emprestimo_id serial primary key,
	livro_id int references livros (livro_id),
	membro_id int references membros (membro_id),
	data_emprestimo date default current_date,
	data_devolucao date,
	devolvido boolean default false,
	data_prevista_devolucao date
);

create table reservas (
	reserva_id serial primary key,
	livro_id int references livros(livro_id),
	membro_id int references membros(membro_id),
	data_reserva date default current_date
);

create table multas(
	multa serial primary key,
	emprestimo_id int references emprestimos (emprestimo_id),
	valor numeric(5,2),
	pago boolean default false
);

-- procedures e triggers: gerar multa automaticamente para livros entregues com atraso
-- procedure para calcular multa
create or replace function gerar_multa() 
returns trigger as $$
begin
	if new.devolvido = True and new.data_devolucao > new.data_prevista_devolucao then
	-- calcular valor da multa como 1.50 por dia de atraso
	insert into multas(emprestimo_id,valor) values
	(new.emprestimo_id,(new.data_devolucao - new.data_prevista_devolucao)*1.50);
	end if;
return new;
end;
$$language plpgsql;

-- trigger que chama a procedure gerar_multa() ao devolver o livro
create trigger trigger_gerar_multa
after update of devolvido on emprestimos
for each row
when (new.devolvido=True)
execute function gerar_multa();


-- view para listar membros com emprestimos em atraso
create view membros_em_atraso as
select m.membro_id, m.nome, e.data_prevista_devolucao from Membros m
join emprestimos e on m.membro_id = e.membro_id
where e.devolvido = false and e.data_prevista_devolucao < current_date;

-- indice para acelerar consultas por titulo de livro
create index idx_livros_titulo on livros (titulo);

-- populando o banco de dados
insert into Autores (nome) values
('J.K.Rowling'),('George R.R. Martin'), ('J.R.R.Tolkien');

insert into livros (titulo,autor_id,estoque,ano_publicacao,isbn) values
('Harry Potter e a Pedra Filosofal', 1, 5, 1997, '9780747532699'),
('Game of Thrones',2,3,1996,'9780553103540'),
('O Senhor dos Anéis',3,4,1954,'9780618640157');

insert into Membros (nome,endereco,email) values
('João da silva', 'Rua das Flores, 123', 'joao@email.com'),
('Maria Souza', 'Av. Brasil, 456', 'maria@email.com');

insert into emprestimos (livro_id,membro_id,data_prevista_devolucao) values
(1,1,'2024-10-08'), (2,2,'2024-10-10');


select * from autores;
select * from livros;
select * from Membros;
select * from emprestimos;
select * from multas;

update emprestimos set data_devolucao='2024-10-25', devolvido = 'true' where emprestimo_id = 3;























