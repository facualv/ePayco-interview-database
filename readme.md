# VIRTUAL WALLET DATA BASE

Base de datos desarrollada para simular una billetera virtual

## Stack Tecnológico

- MySql
- MySql WorkBench 8.0

## Diagrama Entidad Relacion

![Relationship Diagram](/RelationshipDiagram.png)

## Objetos de la base de datps

### Tablas

- Client
- Wallet
- Transaction

### Triggers

- TABLA CLIENT: tgr_wallet_creator
  Cada vez que se crea un cliente automaticamente se crea una billetera

- TABLA TRANSACTION: tgr_balance_updater`
  Cada vez que se inserta un registro en la tabla transaction el trigger verifica el tipo de la operacion a traves del campo type. Si es 'payment' descuenta el valor de la operacion del saldo de la billetera, por el contrario, si el valor del campo type es 'recharge' adiciona el valor de la operacion a la billetera.
