create database fazenda_palmitos_isabelyLemos;
use fazenda_palmitos_isabelyLemos;

create table palmito (
id_palmito int auto_increment primary key,
tipo_palmito varchar (50),
preco_venda decimal (10,2),
estoque_atual int,
data_plantio date,
data_colheita date
);

insert into palmito(tipo_palmito, preco_venda, estoque_atual, data_plantio, data_colheita) values
("Pupunha", 15.50, 200, "2023-02-15", "2024-02-15"), ("Açaí", 10.00, 150, "2023-01-10", "2024-01-10"),
("Jussara", 18.75, 80, "2023-03-05", "2024-03-05"), ("Real", 20.00, 60, "2023-04-20", "2024-04-20"),
("Pupunha Premium", 25.00, 40, "2023-05-15", "2024-05-15"), ("Açaí Orgânico", 12.50, 100, "2023-06-10", "2024-06-10"),
("Jussara Orgânico", 19.00, 70, "2023-07-22", "2024-07-22"), ("Real Orgânico", 22.50, 30, "2023-08-01", "2024-08-01"),
("Pupunha Orgânico", 16.50, 50, "2023-09-05", "2024-09-05"), ("Açaí Premium", 13.50, 120, "2023-10-12", "2024-10-12");

create table fornecedor (
id_fornecedor int auto_increment primary key,
nome_fornecedor varchar (100),
contato varchar (15),
cidade varchar (100)
);

insert into fornecedor (nome_fornecedor, contato, cidade) values
("Fazenda Verde", "(11) 98765-4321", "São Paulo"), ("AgroPalm", "(21) 91234-5678", "Rio de Janeiro"),
("Orgânicos S.A.", "(47) 99876-5432", "Florianópolis"), ("EcoPlanta", "(31) 92345-6789", "Belo Horizonte"),
("Sustenta Verde", "(61) 99999-9999", "Brasília"), ("HortiVida", "(81) 97654-3210", "Recife"),
("AgroPalmito", "(19) 93210-5678", "Campinas"), ("VerdeOrg", "(41) 94321-7654", "Curitiba"),
("PlantarBem", "(62) 95432-1098", "Goiânia"), ("BioPalm", "(85) 98765-1234", "Fortaleza");

create table compra (
id_compra int auto_increment primary key,
id_palmito int,
quantidade_comprada int,
data_compra date, 
preco_total decimal (10,2),
constraint id_palmito_fk foreign key (id_palmito) references palmito (id_palmito)
);

insert into compra (id_palmito, quantidade_comprada, data_compra, preco_total) values
(1, 100, "2024-01-05", 1550.00), (2, 50, "2024-01-12", 500.00),
(3, 40, "2024-01-18", 750.00), (4, 20, "2024-02-01", 400.00),
(5, 10, "2024-02-15", 250.00), (6, 80, "2024-02-20", 1000.00),
(7, 50, "2024-02-25", 950.00), (8, 30, "2024-03-02", 675.00),
(9, 40, "2024-03-10", 660.00), (10, 70, "2024-03-18", 945.00);

create table venda (
id_venda int auto_increment primary key,
id_palmito int,
quantidade_vendida int,
data_venda date,
preco_total decimal (10,2),
constraint id_palmito_fk_venda foreign key (id_palmito) references palmito (id_palmito)
);

insert into venda (id_palmito, quantidade_vendida, data_venda, preco_total) values
(1, 50, "2024-03-10", 775.00), (2, 30, "2024-03-15", 300.00),
(3, 20, "2024-03-20", 375.00), (4, 10, "2024-03-25", 200.00),
(5, 5, "2024-04-05", 125.00), (6, 40, "2024-04-10", 500.00),
(7, 35, "2024-04-12", 665.00), (8, 20, "2024-04-18", 450.00),
(9, 25, "2024-04-20", 412.50), (10, 60, "2024-04-22", 810.00);

-- Consulta 1:
select venda.quantidade_vendida, venda.data_venda, venda.preco_total, palmito.tipo_palmito from venda
join palmito using (id_palmito)
where tipo_palmito = "Açaí";

-- Consulta 2:
select * from venda order by data_venda desc;

-- Consulta 3:
select palmito.tipo_palmito as "Tipo de Palmito", venda.quantidade_vendida as "Total de Vendas" from venda
join palmito using (id_palmito)
group by id_palmito;

-- Consulta 4:








