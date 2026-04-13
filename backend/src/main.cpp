// server.cpp
#include <boost/asio.hpp>
#include <iostream>
#include <dotenv.h>
#include "DataBase.h"
#include <array>

using boost::asio::ip::tcp;
//Received JSON: {"data":{"birthday":"Thu May 15 1924","fullname":"Иванов Иван Иванович","height":155,"phone":"","weight":44},"type":"create_patient"}
int main() {
    dotenv::env.load_dotenv();
    DataBase db;
    try {
        boost::asio::io_context io;

        tcp::acceptor acceptor(io, tcp::endpoint(tcp::v4(), 5555));
        std::cout << "Server started on port 5555\n";

        for (;;) {
            tcp::socket socket(io);
            acceptor.accept(socket);

            uint32_t size;
            boost::asio::read(socket, boost::asio::buffer(&size, sizeof(size)));
            size = ntohl(size);

            std::vector<char> buffer(size);
            boost::asio::read(socket, boost::asio::buffer(buffer));

            std::string packet(buffer.begin(), buffer.end());
            std::cout << "Received JSON: " << packet << std::endl;
            nlohmann::json json = nlohmann::json::parse(packet);
            if (json["type"] == "create_patient") {
                db.add_patient(json["data"].get<Patient>());
            }
        }
    }
    catch (std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }
}