// server.cpp
#include <boost/asio.hpp>
#include <iostream>
#include <array>

using boost::asio::ip::tcp;

int main() {
    try {
        boost::asio::io_context io;

        tcp::acceptor acceptor(io, tcp::endpoint(tcp::v4(), 5555));
        std::cout << "Server started on port 5555\n";

        for (;;) {
            tcp::socket socket(io);
            acceptor.accept(socket);

            std::array<char, 1024> buffer{};
            boost::system::error_code ec;

            size_t length = socket.read_some(boost::asio::buffer(buffer), ec);

            if (!ec) {
                std::string message(buffer.data(), length);
                std::cout << "Received: " << message << std::endl;

                std::string reply = "OK";
                boost::asio::write(socket, boost::asio::buffer(reply));
            }
        }
    }
    catch (std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }
}