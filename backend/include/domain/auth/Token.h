//
// Created by konstantin on 03.05.2026.
//

#ifndef PAINAPP_TOKEN_H
#define PAINAPP_TOKEN_H
#include <array>
#include <string>
#include <openssl/rand.h>
#include <openssl/sha.h>

template <size_t N>
struct Token {
public:
    static constexpr size_t TOKEN_SIZE = N;
private:
    static constexpr size_t base64_encoded_length(size_t n) {
        return 4 * ((n + 2) / 3);
    }

    static constexpr size_t base64_padding(size_t n) {
        return (3 - (n % 3)) % 3;
    }
    std::array<uint8_t, N> bytes;
public:
    static constexpr size_t base64url_length =
    base64_encoded_length(N) - base64_padding(N);

    using Base64UrlString = std::array<char, base64url_length>;
    static Token generate() {
        Token t;
        RAND_bytes(t.bytes.data(), t.bytes.size());
        return t;
    }
    std::string to_string() const {
        return to_base64url(bytes.data(), bytes.size());
    }
    operator std::string () const {
        return to_string();
    }

private:
    std::string to_base64url(const uint8_t* data, size_t size) const {
        size_t out_len = 4 * ((N + 2) / 3);
        std::string out(out_len, '\0');
        EVP_EncodeBlock(reinterpret_cast<unsigned char*>(&out[0]), data, N);
        for (char& c : out) {
            if (c == '+') c = '-';
            else if (c == '/') c = '_';
        }
        while (!out.empty() && out.back() == '=')
            out.pop_back();
        return out;
    }
    static Token from_base64url(std::string_view input) {
        if (input.size() != base64url_length)
            throw std::runtime_error("Invalid token length");

        std::string b64(input);

        for (char& c : b64) {
            if (c == '-') c = '+';
            else if (c == '_') c = '/';
        }

        size_t padding = (4 - (b64.size() % 4)) % 4;
        b64.append(padding, '=');

        Token token{};

        int len = EVP_DecodeBlock(
            reinterpret_cast<unsigned char*>(token.bytes.data()),
            reinterpret_cast<const unsigned char*>(b64.data()),
            b64.size()
        );

        if (len < 0 || static_cast<size_t>(len) < N)
            throw std::runtime_error("Invalid token");

        return token;
    }
};

template <size_t len>
struct TokenHash {
    std::array<uint8_t, len> bytes;
    static constexpr size_t HASH_SIZE = len;
    template <size_t N>
    static TokenHash hash(const Token<N>& t) {
        TokenHash h;
        SHA256(t.bytes.data(), t.bytes.size(), h.bytes.data());
        return h;
    }
    bool operator==(const TokenHash& other) const {
        return bytes == other.bytes;
    }
};
using TokenHash32 = TokenHash<32>;
#endif //PAINAPP_TOKEN_H
