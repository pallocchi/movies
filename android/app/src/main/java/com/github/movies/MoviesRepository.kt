/*
 * MIT License
 *
 * Copyright (c) 2018 Pablo Pallocchi
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 */
package com.github.movies

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import java.nio.ByteBuffer
import java.nio.ByteOrder

class MoviesRepository(val context: Context) {

    private var helper: DBHelper? = null

    private fun getDatabase(): SQLiteDatabase {

        if (helper == null) {
            helper = DBHelper(context)
        }

        if (helper != null) {
            return helper!!.readableDatabase
        } else {
            throw IllegalArgumentException("Database not readable!")
        }
    }

    /**
     * Get the top n movies from the repository.
     */
    fun top(limit: Int = 100): List<Movie> {
        val movies = mutableListOf<Movie>()
        val cursor = getDatabase().rawQuery("SELECT title, overview, poster FROM movies LIMIT $limit", null)
        if (cursor.moveToFirst()) {
            do {
                val movie = Movie(
                        title = cursor.getString(0),
                        overview = cursor.getString(1),
                        poster = cursor.getString(2))
                movies.add(movie)
            } while (cursor.moveToNext())
        }
        cursor.close()
        return movies
    }

    /**
     * Get the movies that match a given text.
     */
    fun search(text: String): List<Movie> {
        val movies = mutableListOf<Movie>()
        val cursor = getDatabase().rawQuery("SELECT title, overview, poster, matchinfo(movies, 'pcnalx') FROM movies WHERE movies MATCH '$text*'", null)
        if (cursor.moveToFirst()) {
            do {
                val score = OkapiBM25.score(matchinfo = cursor.getBlob(3).toIntArray(), column = 0)
                val movie = Movie(
                        title = cursor.getString(0),
                        overview = cursor.getString(1),
                        poster = cursor.getString(2),
                        score = score)
                movies.add(movie)
            } while (cursor.moveToNext())
        }
        cursor.close()
        return movies.sortedByDescending { it.score }
    }

    /**
     * Convert byte array to int array (little endian).
     */
    fun ByteArray.toIntArray(): Array<Int> {
        val intBuf = ByteBuffer.wrap(this)
                .order(ByteOrder.LITTLE_ENDIAN)
                .asIntBuffer()
        val array = IntArray(intBuf.remaining())
        intBuf.get(array)
        return array.toTypedArray()
    }

}