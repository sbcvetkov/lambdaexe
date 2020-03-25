#!/usr/bin/env python3

import psycopg2
import boto3
import os, sys

def get_ssm_secret(user, password, db):
    ssm = boto3.client("ssm")
    rds_user = ssm.get_parameter(
        Name=user,
        WithDecryption=True
    )
    rds_pass = ssm.get_parameter(
        Name=password,
        WithDecryption=True
    )
    rds_url = ssm.get_parameter(
        Name=db,
        WithDecryption=True
    )

    return rds_user['Parameter']['Value'], rds_pass['Parameter']['Value'], rds_url['Parameter']['Value']

def get_lambdaexe_db_data(rds_user, rds_pass, rds_endpoint):
    engine = None
    
    try:
        rds = boto3.client("rds")
        engine = psycopg2.connect(
            database = "postgres",
            user = rds_user,
            password = rds_pass,
            host = rds_endpoint.replace('"', ''),
            port = "5432"
        )
        cur = engine.cursor()
        cur.execute('SELECT version()')

        version = cur.fetchone()[0]
        print(version)

    except psycopg2.DatabaseError as e:

        print(f'Error {e}')
        sys.exit(1)

    finally:
        if engine:
            engine.close()

if __name__ == "__main__":
    session = boto3.Session()
    rds_user, rds_pass, rds_endpoint = get_ssm_secret("/lambdaexe/vars/lambdaexe_db_user", "/lambdaexe/vars/lambdaexe_db_pass", "/lambdaexe/vars/lambdaexe_db_codecommit_url")
    get_lambdaexe_db_data(rds_user, rds_pass, rds_endpoint)
    
