defmodule Ecv do
  @moduledoc false

  alias Evision, as: Cv

  @image_url "https://upload.wikimedia.org/wikipedia/en/7/7d/Lenna_%28test_image%29.png"

  def download_image do
    Helper.download!(
      @image_url,
      fetch_path()
    )
  end

  def fetch_path do
    # Path.join(File.cwd!(), "image.png")
    # Path.join(File.cwd!(), "cats.jpg")
    Path.join(File.cwd!(), "people.jpg")
  end

  def read_image(image_path) do
    # Cv.imread(image_path, flags: Cv.Constant.cv_IMREAD_GRAYSCALE())
    Cv.imread(image_path, flags: Cv.Constant.cv_IMREAD_COLOR())
  end

  def run do
    image = fetch_path() |> read_image()
    cascade = cascade_file_path() |> load_cascade()

    rects = detect_object(image, cascade)

    result_image = draw_boxes(image, rects)

    Cv.imencode(".jpg", result_image)
    |> Kino.Image.new(:jpg)
    |> save_file("output.jpg")
  end

  def load_cascade(cascade_file_path) do
    Cv.CascadeClassifier.cascadeClassifier(cascade_file_path)
  end

  def cascade_file_path do
    # Path.join(File.cwd!(), "haarcascade_frontalcatface.xml")
    Path.join(File.cwd!(), "smile_cascade.xml")
  end

  def detect_object(image, cascade) do
    Cv.CascadeClassifier.detectMultiScale(cascade, image)
  end

  def draw_boxes(image, rects) do
    Enum.reduce(rects, image, fn {x, y, w, h}, img ->
      Cv.rectangle(img, {x, y}, {x + w, y + h}, {0, 255, 0}, thickness: 2)
    end)
  end

  def save_file(image_binary, file_name) do
    File.cwd!()
    |> Path.join(file_name)
    |> File.write!(image_binary.content)
  end
end
