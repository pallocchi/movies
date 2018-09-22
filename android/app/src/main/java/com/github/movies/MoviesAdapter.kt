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

import android.widget.TextView
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import com.squareup.picasso.Picasso

class MoviesAdapter(val movies: List<Movie>) : RecyclerView.Adapter<MoviesAdapter.ViewHolder>() {

    override fun onCreateViewHolder(viewGroup: ViewGroup, i: Int): MoviesAdapter.ViewHolder {
        val view = LayoutInflater.from(viewGroup.context).inflate(R.layout.movie, viewGroup, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: MoviesAdapter.ViewHolder, i: Int) {
        holder.bind(movie = movies[i])
    }

    override fun getItemCount(): Int {
        return movies.size
    }

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {

        private val imageBasePath = "https://image.tmdb.org/t/p/w200"

        private val title: TextView = view.findViewById(R.id.title)
        private val overview: TextView = view.findViewById(R.id.overview)
        private val poster: ImageView = view.findViewById(R.id.poster)

        fun bind(movie: Movie) {
            title.text = movie.title
            overview.text = movie.overview
            Picasso.get().load(imageBasePath + movie.poster).fit().placeholder(R.drawable.poster).into(poster)
        }

    }

}