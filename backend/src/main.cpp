// server.cpp
#include <boost/asio.hpp>
#include <iostream>
#include <array>

using boost::asio::ip::tcp;
//Received JSON: {"data":{"birthday":"Thu May 15 1924","fullname":"Иванов Иван Иванович","height":155,"phone":"","weight":44},"type":"create_patient"}
int main() {
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

            std::string json(buffer.begin(), buffer.end());
            std::cout << "Received JSON: " << json << std::endl;  
        }
    }
    catch (std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }
}