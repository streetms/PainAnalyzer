#include "TestDataBase.h"
#include "utils/load_dotenv.h"
TestDatabase::TestDatabase()
    : conn(""), txn(conn)
{

}

TestDatabase::~TestDatabase()
{
    txn.abort();
}
